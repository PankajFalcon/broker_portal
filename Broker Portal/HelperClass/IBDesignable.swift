//
//  IBDesignable.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit

@IBDesignable
public extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    /// Programmatically apply basic style
    func applyStyle(
        cornerRadius: CGFloat = 0,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0,
        shadowColor: UIColor? = nil,
        shadowOpacity: Float = 0,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = 0
    ) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
    }
}

@IBDesignable
public extension UITextField {
    
    @IBInspectable var leftPadding: CGFloat {
        get {
            return leftView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rightPadding: CGFloat {
        get {
            return rightView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        get { return nil } // Not used for getting
        set {
            if let image = newValue {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                
                let containerWidth: CGFloat = 36 // image width + padding
                let container = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: 24))
                imageView.frame = CGRect(x: 8, y: 0, width: 20, height: 24) // 8pt padding
                container.addSubview(imageView)
                
                leftView = container
                leftViewMode = .always
            } else {
                leftView = nil
            }
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        get { return nil }
        set {
            if let image = newValue {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                
                let containerWidth: CGFloat = 36
                let container = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: 24))
                imageView.frame = CGRect(x: 8, y: 0, width: 20, height: 24)
                container.addSubview(imageView)
                
                rightView = container
                rightViewMode = .always
            } else {
                rightView = nil
            }
        }
    }
    
    @IBInspectable var placeholderTextColor: UIColor? {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        }
        set {
            guard let placeholder = placeholder, let color = newValue else { return }
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: color]
            )
        }
    }
}

@IBDesignable
public extension UITextView {
    
    @IBInspectable var horizontalPadding: CGFloat {
        get { return textContainerInset.left } // Assuming symmetrical
        set {
            textContainerInset = UIEdgeInsets(
                top: textContainerInset.top,
                left: newValue,
                bottom: textContainerInset.bottom,
                right: newValue
            )
        }
    }
}
