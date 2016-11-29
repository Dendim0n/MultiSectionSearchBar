//
//  ViewController.swift
//  MultiSelection_SearchBar
//
//  Created by 任岐鸣 on 16/10/8.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let a = CustomSearchView.init();
        view.addSubview(a);
        a.backgroundColor = .yellow
        a.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(50)
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(50)
        }
        a.searchButtonClosure = {
            str in
            print(str)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

