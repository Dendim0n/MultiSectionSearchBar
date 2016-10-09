//
//  CustomSearchView.swift
//  MultiSelection_SearchBar
//
//  Created by 任岐鸣 on 16/10/8.
//  Copyright © 2016年 Ned. All rights reserved.
//

//Usage: SearchButtonClosure -> #doSomething# -> call UpdateSearchMenuData

import UIKit

class CustomSearchView: UIView,UITextFieldDelegate {
    
    typealias doSearchButtonClosure = (String) -> Void
    var searchButtonClosure:doSearchButtonClosure?

    var textField:UITextField!
    var hintText:UILabel!
    var searchPic:UIImageView!
    var cancelButton:UIButton!
    var resultListView:searchMenu!
    
    var hintStr = "Placeholder"
    var isNeedSearchWhileInputing = false
    
    init(frame:CGRect,placeHolder:String) {
        super.init(frame: frame)
        commonInit()
        hintStr = placeHolder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        resultListView = searchMenu.init(frame: self.frame)
        textField = UITextField.init()
        hintText = UILabel.init()
        cancelButton = UIButton.init()
        searchPic = UIImageView.init()
        
        textField.returnKeyType = UIReturnKeyType.search
        cancelButton.addTarget(self, action: #selector(closeList), for: UIControlEvents.touchUpInside)
        hintText.textColor = UIColor.lightGray
        searchPic.contentMode = UIViewContentMode.scaleAspectFit
        searchPic.image = UIImage.init(named: "searchBar")
        cancelButton.alpha = 0
        hintText.text = hintStr
        textField.delegate = self
        cancelButton.backgroundColor = UIColor.lightGray
        
        addSubview(hintText)
        addSubview(searchPic)
        addSubview(textField)
        addSubview(cancelButton)
        
        textField.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(24)
        }
        hintText.snp.makeConstraints { (make) in
            make.center.equalTo(textField)
        }
        searchPic.snp.makeConstraints { (make) in
            make.centerY.equalTo(hintText)
            make.right.equalTo(hintText.snp.left)
            make.height.equalTo(hintText.snp.height)
            make.width.equalTo(hintText.snp.height)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(textField)
            make.centerY.equalTo(textField)
            make.height.equalTo(textField)
            make.width.equalTo(50)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return!")
        if searchButtonClosure != nil {
            searchButtonClosure!(textField.text!)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        animToInput()
        superview?.bringSubview(toFront: self)
        showResult()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" {
            hintText.text = hintStr
        } else {
            hintText.text = ""
            if searchButtonClosure != nil && isNeedSearchWhileInputing {
                searchButtonClosure!(textField.text!)
            }
        }
        return true
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
    
    @objc private func closeList() {
        textField.text = ""
        textField.resignFirstResponder()
        hintText.text = hintStr
        resultListView.removeFromSuperview()
        animToOrigin()
    }
    
    private func animToInput() {
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 1
            self.searchPic.snp.remakeConstraints({ (make) in
                make.right.equalTo(self.hintText.snp.left)
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
            self.cancelButton.alpha = 0
            self.hintText.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
            }
            self.searchPic.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self.hintText)
                make.right.equalTo(self.hintText.snp.left)
                make.height.equalTo(self.hintText.snp.height)
                make.width.equalTo(self.hintText.snp.height)
            }
            self.layoutIfNeeded()
        }
        
    }
    
    func UpdateSearchMenuData(dataArray:Array<Array<String>>,titleArray:Array<String>) {
        resultListView.updateData(dataArray: dataArray, titleArray: titleArray)
    }
}

class searchMenu: UIView,UITableViewDelegate,UITableViewDataSource {
    
    typealias selectRowClosure = (Int,IndexPath) -> Void
    
    var doSelect:selectRowClosure?
    
    var segmentSelector:UISegmentedControl!
    var tableView:UITableView!
    
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
        
        segmentSelector = UISegmentedControl.init()
        tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        
        segmentSelector.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        segmentSelector.selectedSegmentIndex = 0
        
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
//        updateData(dataArray: [["1","2","3","4","5","6"],["11","22","33","44","55","66"],["111","222","333","444","555","666"]], titleArray: ["1","2","3"])
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
            
        }
    }
    
    func segmentChanged() {
        tableView.reloadData()
    }
    
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
        if doSelect != nil {
            doSelect!(segmentSelector.selectedSegmentIndex == -1 ? 0 : segmentSelector.selectedSegmentIndex,indexPath)
        }
    }
    
}
