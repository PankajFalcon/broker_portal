//
//  UITextField.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit

public extension UITextField {
    
    /// Show error message below the text field with red border and shake animation
    func showError(message: String,
                   font: UIFont = .appRegular(12),
                   textColor: UIColor = .red,
                   borderColor: UIColor = .red) {
        
        // Remove existing error label if any
        removeError()
        
        // Add border color
        layer.borderWidth = 1
        layer.cornerRadius = 6
        layer.borderColor = borderColor.cgColor
        
        // Create and configure error label
        let errorLabel = UILabel()
        errorLabel.text = message
        errorLabel.font = font
        errorLabel.textColor = textColor
        errorLabel.numberOfLines = 0
        errorLabel.tag = 999 // tag to identify for cleanup
        
        // Add label below the text field
        guard let superview = self.superview else { return }
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
        ])
        
        // Animate shake
        shake()
    }
    
    /// Remove error label and reset border
    func removeError() {
        superview?.viewWithTag(999)?.removeFromSuperview()
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
    }
    
    /// Shake animation
    private func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-8, 8, -6, 6, -4, 4, -2, 2, 0]
        layer.add(animation, forKey: "shake")
    }
}
