//
//  ViewController.swift
//  Naviline
//
//  Created by Anton Rodzik on 04/20/2019.
//  Copyright (c) 2019 Anton Rodzik. All rights reserved.
//

import UIKit
import Naviline

class ViewController: NavilineController {
    
    var naviline: Naviline
    var navigationContentView: UIView

    var button = UIButton()
    
    init() {
        let configurator = NavilineConfigurator.defaultConfigurator()
        configurator.colors[.backgroundColor] = .red
        configurator.colors[.homeBackgroundColor] = .red
        configurator.colors[.selectedTextColor] = .blue
        configurator.colors[.textColor] = .white
        
        configurator.fonts[.boldFont] = UIFont.boldSystemFont(ofSize: 14.0)
        configurator.fonts[.regularFont] = UIFont.systemFont(ofSize: 14.0)
    
        configurator.height = 44.0
        
        self.naviline = Naviline(configurator: configurator)
        self.navigationContentView = UIView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let configurator = NavilineConfigurator.defaultConfigurator()
                configurator.colors[.backgroundColor] = .red
                configurator.colors[.homeBackgroundColor] = .red
                configurator.colors[.selectedTextColor] = .blue
                configurator.colors[.textColor] = .white
        
                configurator.fonts[.boldFont] = UIFont.boldSystemFont(ofSize: 14.0)
                configurator.fonts[.regularFont] = UIFont.systemFont(ofSize: 14.0)
        
                configurator.height = 44.0
        
        self.naviline = Naviline(configurator: configurator)
        self.navigationContentView = UIView()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(showNextController), for: .touchUpInside)
        naviline.setup(with: self, homeContentController: ContentViewController(index: naviline.size,
                                                                                title: "Controller \(naviline.size)"))
        view.addSubview(naviline)
        view.addSubview(navigationContentView)
        view.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        naviline.backgroundColor = .red
        naviline.frame = CGRect(x: 0,
                                y: 44,
                                width: view.frame.width,
                                height: naviline.configurator.height)
        navigationContentView.frame = CGRect(x: 0,
                                             y: naviline.configurator.height + 44,
                                             width: view.frame.width,
                                             height: view.frame.height - naviline.configurator.height)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.center = view.center
    }

    @objc func showNextController() {
        naviline.addController(ContentViewController(index: naviline.size, title: "Controller \(naviline.size)"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

