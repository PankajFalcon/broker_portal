//
//  UITextField.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit
import ObjectiveC

private var errorLabelKey: UInt8 = 0

public extension UITextField {
    
    func showError(message: String,
                   font: UIFont = .appRegular(12,true),
                   textColor: UIColor = .red,
                   borderColor: UIColor = .red) {
        
        removeError() // Clean up previous label if any
        
        // Border styling
        layer.borderWidth = 1
        layer.cornerRadius = 6
        layer.borderColor = borderColor.cgColor
        
        // Create error label
        let errorLabel = UILabel()
        errorLabel.text = message
        errorLabel.font = font
        errorLabel.textColor = textColor
        errorLabel.numberOfLines = 0
        
        // Add to superview
        guard let superview = self.superview else { return }
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
        ])
        
        // Save reference using associated object
        objc_setAssociatedObject(self, &errorLabelKey, errorLabel, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Shake animation
        shake()
    }
    
    func removeError() {
        if let containerView = objc_getAssociatedObject(self, &errorLabelKey) as? UIView {
            containerView.removeFromSuperview()
            objc_setAssociatedObject(self, &errorLabelKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        // Reset to system-default look
        layer.borderWidth = 0
        layer.borderColor = nil
    }
    
    private func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-8, 8, -6, 6, -4, 4, -2, 2, 0]
        layer.add(animation, forKey: "shake")
    }
}
