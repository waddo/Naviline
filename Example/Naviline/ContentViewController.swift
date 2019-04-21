//
//  ContentViewController.swift
//  Naviline_Example
//
//  Created by Anton Rodzik on 4/21/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Naviline

class ContentViewController: NavilineContentController {
    
    var navigationTitle: String
    
    var navigationIndex: Int
    
    var navilineController: NavilineControllerProtocol?
    
    let label = UILabel()
    
    init(index: Int, title: String) {
        self.navigationIndex = index
        self.navigationTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        label.text = self.navigationTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.frame = view.bounds
    }
}
