//
//  UIView.swift
//  Broker Portal
//
//  Created by Pankaj on 17/06/25.
//

import UIKit

extension UIView {
    func showPopTip(
        message: String,
        backgroundColor: UIColor = .AppWhiteColor,
        textColor: UIColor = .AppLightGrey,
        borderColor: UIColor = .AppLightGrey,
        font: UIFont = .appSemibold(14, false),
        cornerRadius: CGFloat = 8
    ) {
        let tip = PopTipView(
            message: message,
            backgroundColor: backgroundColor,
            textColor: textColor,
            borderColor: borderColor,
            font: font,
            cornerRadius: cornerRadius
        )
        tip.show(from: self)
    }
}

//MARK: - Dotted Line Code

@IBDesignable
final class DottedView: UIView {
    
    // MARK: - Inspectable Properties for Storyboard
    @IBInspectable var dottedColor: UIColor = .black
    @IBInspectable var dottedLineWidth: CGFloat = 1
    @IBInspectable var dottedCornerRadius: CGFloat = 0
    @IBInspectable var dottedDashLength: CGFloat = 4
    @IBInspectable var dottedGapLength: CGFloat = 4
    @IBInspectable var dottedPosition: String = "border" // "border", "top", "bottom", "left", "right"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawDotted()
    }
    
    private func drawDotted() {
        layer.sublayers?.removeAll(where: { $0.name == "DottedLineLayer" })
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DottedLineLayer"
        shapeLayer.strokeColor = dottedColor.cgColor
        shapeLayer.lineWidth = dottedLineWidth
        shapeLayer.lineDashPattern = [dottedDashLength as NSNumber, dottedGapLength as NSNumber]
        shapeLayer.fillColor = nil
        
        let path = UIBezierPath()
        
        switch dottedPosition.lowercased() {
        case "top":
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
            
        case "bottom":
            path.move(to: CGPoint(x: 0, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            
        case "left":
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: bounds.height))
            
        case "right":
            path.move(to: CGPoint(x: bounds.width, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            
        default: // border
            shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: dottedCornerRadius).cgPath
        }
        
        if dottedPosition.lowercased() != "border" {
            shapeLayer.path = path.cgPath
        }
        
        shapeLayer.frame = bounds
        layer.addSublayer(shapeLayer)
    }
}
