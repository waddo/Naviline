//
//  NavilineConfigurator.swift
//  Naviline
//
//  Created by Anton Rodzik on 4/20/19.
//

import UIKit

public enum NavilineColor {
    case homeBackgroundColor
    case backgroundColor
    case selectedTextColor
    case textColor
}

public enum NavilineFont {
    case regularFont
    case boldFont
}

public final class NavilineConfigurator {
    
    public var colors: [NavilineColor: UIColor] = [
        .homeBackgroundColor: UIColor(58, 58, 64),
        .backgroundColor: UIColor(68, 68, 75),
        .selectedTextColor: UIColor(66, 220, 238),
        .textColor: UIColor(247, 247, 247)]

    public var fonts: [NavilineFont: UIFont] = [
        .regularFont: UIFont.systemFont(ofSize: 10),
        .boldFont: UIFont.boldSystemFont(ofSize: 10)]
    
    public var height: CGFloat = 25.0

    public var homeIcon: UIImage? = UIImage(named: "house-black-silhouette-without-door")
    
    static func defaultConfigurator() -> NavilineConfigurator {
        return NavilineConfigurator()
    }
    
}

fileprivate extension UIColor {
    
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Double? = 1.0) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
}
