//
//  UIFont.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit

public extension CGFloat {
    /// Automatically scales font size for iPad
    var autoScaledForDevice: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return self * 2 // You can tweak this scale
        } else {
            return self
        }
    }
}

public extension UIFont {
    
    // MARK: - System Fonts
    
    static func appRegular(_ size: CGFloat, _ isErrorBool: Bool) -> UIFont {
        return InterFontStyle.regular.with(size: isErrorBool  ? size : size.autoScaledForDevice)
    }
    
    static func appMedium(_ size: CGFloat, _ isErrorBool: Bool) -> UIFont {
        return InterFontStyle.medium.with(size: isErrorBool  ? size : size.autoScaledForDevice)
    }
    
    static func appSemibold(_ size: CGFloat, _ isErrorBool: Bool) -> UIFont {
        return InterFontStyle.semiBold.with(size: isErrorBool  ? size : size.autoScaledForDevice)
    }
    
    static func appBold(_ size: CGFloat, _ isErrorBool: Bool) -> UIFont {
        return InterFontStyle.bold.with(size: isErrorBool  ? size : size.autoScaledForDevice)
    }
    
    static func appItalic(_ size: CGFloat, _ isErrorBool: Bool) -> UIFont {
        return InterFontStyle.italic.with(size: isErrorBool  ? size : size.autoScaledForDevice)
    }
    
    static func customFont(name: String, size: CGFloat, fallbackWeight: UIFont.Weight = .regular) -> UIFont {
        return UIFont(name: name, size: size.autoScaledForDevice) ?? UIFont.systemFont(ofSize: size.autoScaledForDevice, weight: fallbackWeight)
    }
}

enum InterFontStyle: String, CaseIterable {
    case black = "Inter-Black"
    case blackItalic = "Inter-BlackItalic"
    case bold = "Inter-Bold"
    case boldItalic = "Inter-BoldItalic"
    case extraBold = "Inter-ExtraBold"
    case extraBoldItalic = "Inter-ExtraBoldItalic"
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case light = "Inter-Light"
    case thin = "Inter-Thin"
    case semiBold = "Inter-SemiBold"
    case italic = "Inter-Italic"
    
    func with(size: CGFloat) -> UIFont {
        UIFont(name: self.rawValue, size: size.autoScaledForDevice) ?? UIFont.systemFont(ofSize: size.autoScaledForDevice)
    }
}
