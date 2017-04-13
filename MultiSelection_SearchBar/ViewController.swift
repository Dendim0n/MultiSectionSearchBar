//
//  ViewController.swift
//  MultiSelection_SearchBar
//
//  Created by 任岐鸣 on 16/10/8.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let searchTitleString = ["hello","search"]
    let searchDataArray = [["hello","world"],["this","is","the","search","result"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let a = CustomSearchView.init();
        view.addSubview(a);
        a.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
        a.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(50)
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(50)
        }
        a.searchButtonClicked = {
            str in
            print(str)
            a.updateSearchMenuData(dataArray: self.searchDataArray, titleArray: self.searchTitleString)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

