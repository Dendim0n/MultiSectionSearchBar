//
//  CustomSearchView.swift
//  MultiSelection_SearchBar
//
//  Created by 任岐鸣 on 16/10/8.
//  Copyright © 2016年 Ned. All rights reserved.
//

//Usage: SearchButtonClosure -> #doSomething# -> call UpdateSearchMenuData
//

import UIKit

protocol SearchResultDelegate {
    func closeList()
}

class CustomSearchView: UIView,UITextFieldDelegate,SearchResultDelegate {
    
    typealias doSearchButtonClosure = (String) -> Void
    typealias selectRowClosure = (Int,IndexPath) -> Void
    var searchButtonClicked:doSearchButtonClosure?
    var searchResultClicked:selectRowClosure?
    
    var hintStr = "Placeholder" {
        didSet {
            hintText.text = hintStr
        }
    }
    var isNeedSearchWhileInputing = false
    
    init(frame:CGRect,placeHolder:String) {
        super.init(frame: frame)
        setUI()
        hintStr = placeHolder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    func updateSearchMenuData(dataArray:Array<Array<String>>,titleArray:Array<String>) {
        resultListView.updateData(dataArray: dataArray, titleArray: titleArray)
    }
    
    //MARK: - UI
    lazy var textField:UITextField = {
        let txt = UITextField()
        txt.delegate = self
        txt.returnKeyType = .search
        return txt
    }()
    lazy var hintText:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.text = self.hintStr
        return lbl
    }()
    
    lazy var searchPic:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage.init(named: "searchBar")
        return iv
    }()
    
    lazy var cancelButton:UIButton = {
        let btn = UIButton.init()
        btn.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.layer.cornerRadius = 3
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.borderWidth = 0.5
        return btn
    }()
    
    lazy var resultListView:searchMenu = {
        let list = searchMenu.init(frame: self.frame)
        list.doSelect = self.searchResultClicked
        list.delegate = self
        return list
    }()
    
    private func setUI(){
        cancelButton.alpha = 0
        addSubview(hintText)
        addSubview(searchPic)
        addSubview(textField)
        addSubview(cancelButton)
        
        textField.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        hintText.snp.makeConstraints { (make) in
            make.center.equalTo(textField)
        }
        searchPic.snp.makeConstraints { (make) in
            make.centerY.equalTo(hintText)
            make.right.equalTo(hintText.snp.left).offset(-4)
            make.height.equalTo(hintText.snp.height)
            make.width.equalTo(hintText.snp.height)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(textField)
            make.centerY.equalTo(textField)
            make.height.equalTo(textField)
            make.width.equalTo(80)
        }
    }
    
    private func showResult() {
        superview?.addSubview(resultListView)
        superview?.bringSubview(toFront: resultListView)
        resultListView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.bottom)
            make.bottom.equalTo(superview!)
            make.width.equalTo(self)
            make.centerX.equalTo(self)
        }
    }
    
    @objc private func cancel() {
        textField.text = ""
        closeList()
    }
    
    func closeList() {
        textField.resignFirstResponder()
        if let text = textField.text {
            if text != "" {
                hintText.text = ""
            } else {
                hintText.text = hintStr
            }
        } else {
            hintText.text = hintStr
        }
        resultListView.removeFromSuperview()
        animToOrigin()
    }
    
    private func animToInput() {
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 1
            self.searchPic.snp.remakeConstraints({ (make) in
                make.right.equalTo(self.hintText.snp.left).offset(-4)
                make.centerY.equalToSuperview()
                make.height.equalToSuperview()
            })
            self.hintText.snp.remakeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.height.equalToSuperview()
                make.left.equalTo(self.textField)
            })
            self.layoutIfNeeded()
        }
    }
    
    private func animToOrigin() {
        UIView.animate(withDuration: 0.3) {
            if let text = self.textField.text {
                if text != "" {
                    self.cancelButton.alpha = 1
                } else {
                    self.cancelButton.alpha = 0
                }
            } else {
                self.cancelButton.alpha = 0
            }
            
            self.hintText.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
            }
            self.searchPic.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self.hintText)
                make.right.equalTo(self.hintText.snp.left).offset(-4)
                make.height.equalTo(self.hintText.snp.height)
                make.width.equalTo(self.hintText.snp.height)
            }
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return!")
        searchButtonClicked?(textField.text!)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        animToInput()
        superview?.bringSubview(toFront: self)
        if let text = textField.text {
            if text != "" {
                hintText.text = ""
            }
        } else {
            hintText.text = hintStr
        }
        showResult()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" {
            hintText.text = hintStr
        } else {
            hintText.text = ""
            if isNeedSearchWhileInputing {
                searchButtonClicked?(textField.text!)
            }
        }
        return true
    }
}

class searchMenu: UIView,UITableViewDelegate,UITableViewDataSource {
    
    typealias selectRowClosure = (Int,IndexPath) -> Void
    var doSelect:selectRowClosure?
    var delegate:SearchResultDelegate?
    
    lazy var segmentSelector:UISegmentedControl = {
        let seg = UISegmentedControl()
        seg.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        seg.selectedSegmentIndex = 0
        return seg
    }()
    lazy var tableView:UITableView = {
        let tbl = UITableView()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.tableFooterView = UIView()
        return tbl
    }()
    
    var dataSourceArray:Array<Array<String>> = [[]]
    var segmentTitleArray:Array<String> = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(segmentSelector)
        addSubview(tableView)
        segmentSelector.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(30)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentSelector.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func updateData(dataArray:Array<Array<String>>,titleArray:Array<String>) {
        
        segmentTitleArray = titleArray
        dataSourceArray = dataArray
        
        if segmentTitleArray.count <= 1 {
            segmentSelector.snp.updateConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(0)
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(0)
            })
        } else {
            segmentSelector.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(20)
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(30)
            }
            segmentSelector.removeAllSegments()
            for titleStr in segmentTitleArray {
                segmentSelector.insertSegment(withTitle: titleStr, at: segmentTitleArray.index(of: titleStr)!, animated: false)
            }
            segmentSelector.selectedSegmentIndex = 0
            tableView.reloadData()
        }
    }
    
    func segmentChanged() {
        tableView.reloadData()
    }
    
    //MARK: - UITableView Datasource & Deleagte
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentSelector.selectedSegmentIndex < 0 {
            return dataSourceArray[0].count - 1;
        }
        return dataSourceArray[segmentSelector.selectedSegmentIndex].count - 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        let dataSourceIndex = segmentSelector.selectedSegmentIndex == -1 ? 0 : segmentSelector.selectedSegmentIndex
        let dataSource = dataSourceArray[dataSourceIndex]
        
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doSelect?(segmentSelector.selectedSegmentIndex == -1 ? 0 : segmentSelector.selectedSegmentIndex,indexPath)
        delegate?.closeList()
    }
    
}
