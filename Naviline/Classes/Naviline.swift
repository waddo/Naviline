//
//  NavigationStack.swift
//  Voka
//
//  Created by Anton Rodzik on 4/10/19.
//  Copyright © 2019 Anton Rodzik. All rights reserved.
//

import UIKit

public typealias NavilineController = UIViewController & NavilineControllerProtocol
public typealias NavilineContentController = UIViewController & NavilineContentControllerProtocol

public protocol NavilineControllerProtocol: class {
    var naviline: Naviline { get }
    var navigationContentView: UIView { get }
}

public protocol NavilineContentControllerProtocol: class {
    var navigationTitle: String { get }
    var navigationIndex: Int { get set }
    var navilineController: NavilineControllerProtocol? { get }
}

public final class Naviline: UIView {
    
    public var configurator: NavilineConfigurator!
    
    public var size: Int {
        return controllers.count
    }
    
    private var base: NavilineController?
    private var controllers: [NavilineContentController] = []
    private var buttons: [UIButton] = []
    
    private var homeButton: UIButton = {
        let button = UIButton()
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(removeAllAfter(_:)), for: .touchUpInside)
        button.layer.applySketchShadow(alpha: 0.15,
                                       x: 3,
                                       y: 0,
                                       blur: 5,
                                       spread: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        return button
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var lastTrailingAnchorConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        self.configurator = NavilineConfigurator.defaultConfigurator()
    }
    
    public convenience init(configurator: NavilineConfigurator) {
        self.init(frame: .zero)
        self.configurator = configurator
    }
    
    public func setup(with base: NavilineController,
                      homeContentController: NavilineContentController) {
        
        self.base = base
        
        homeButton.backgroundColor = configurator.colors[.homeBackgroundColor]
        homeButton.tintColor = configurator.colors[.selectedTextColor]
        homeButton.setImage(configurator.homeIcon, for: .normal)

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        addSubview(homeButton)
        
        homeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        homeButton.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        homeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        homeButton.widthAnchor.constraint(equalToConstant: 49.0).isActive = true

        scrollView.leftAnchor.constraint(equalTo: homeButton.rightAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        let height: CGFloat = configurator.height
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        controllers.append(homeContentController)
        homeContentController.navigationIndex = controllers.count
        base.add(homeContentController, contentView: base.navigationContentView)
    }
    
    public func addController(_ controller: NavilineContentController) {
        controllers.append(controller)
        controller.navigationIndex = controllers.count
        base?.add(controller, contentView: base?.navigationContentView)
        guard controllers.count > 1 else { return }
        let button: UIButton = {
            let button = UIButton()
            button.backgroundColor = configurator.colors[.backgroundColor]
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            button.setTitle(controller.navigationTitle, for: .normal)
            button.layer.applySketchShadow(alpha: 0.15,
                                           x: 3,
                                           y: 0,
                                           blur: 5,
                                           spread: 0)
            button.tag = buttons.count + 1
            button.addTarget(self, action: #selector(removeAllAfter(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        addButton(button: button)
    }
    
    @objc func removeAllAfter(_ sender: UIButton) {
        let index = sender.tag
        guard index < controllers.count else { return }
        for i in stride(from: controllers.count - 1, to: index, by: -1) {
            let controller = controllers[i]
            controller.remove()
            removeButton()
            controllers.removeLast()
        }
    }
    
    private func addButton(button: UIButton) {
        contentView.insertSubview(button, at: 0)
        
        lastTrailingAnchorConstraint?.isActive = false
        
        if let lastButton = buttons.last {
            button.leadingAnchor.constraint(equalTo: lastButton.trailingAnchor).isActive = true
        } else {
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        }
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        lastTrailingAnchorConstraint = button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        lastTrailingAnchorConstraint?.isActive = true

        buttons.append(button)
        updateButtons()
        updateContentOffset()
    }
    
    private func removeButton() {
        let button = buttons.removeLast()
        button.removeFromSuperview()
        if let lastButton = buttons.last {
            lastTrailingAnchorConstraint = lastButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            lastTrailingAnchorConstraint?.isActive = true
        }
        updateButtons()
        updateContentOffset()
    }
    
    private func updateButtons() {
        homeButton.tintColor = buttons.count > 0 ? configurator.colors[.textColor] : configurator.colors[.selectedTextColor]
        for button in buttons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            button.setTitleColor(configurator.colors[.textColor], for: .normal)
        }
        buttons.last?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        buttons.last?.setTitleColor(configurator.colors[.selectedTextColor], for: .normal)
    }
    
    private func updateContentOffset() {
        scrollView.layoutIfNeeded()
        guard scrollView.contentSize.width > scrollView.frame.width else { return }
        scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.width, y: 0), animated: false)
    }
    
}

fileprivate extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

fileprivate extension UIViewController {
    
    func add(_ child: UIViewController, contentView: UIView? = nil) {
        let aView = contentView != nil ? contentView : self.view
        guard let view = aView else {
            return
        }
        addChild(child)
        view.addSubview(child.view)
        constraintViewEqual(holderView: view, view: child.view)
        child.didMove(toParent: self)
        child.willMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func constraintViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: holderView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: holderView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: holderView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: holderView.bottomAnchor).isActive = true
    }
    
}

