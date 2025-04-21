//
//  UIFont.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit

public extension UIFont {
    
    // MARK: - System Fonts
    
    static func appRegular(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func appMedium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func appSemibold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func appBold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func appItalic(_ size: CGFloat) -> UIFont {
        return UIFont.italicSystemFont(ofSize: size)
    }
    
    // MARK: - Custom Font (Example)
    
    /// Use this if you have a custom font added to the project
    static func customFont(name: String, size: CGFloat, fallbackWeight: UIFont.Weight = .regular) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size, weight: fallbackWeight)
    }
}
