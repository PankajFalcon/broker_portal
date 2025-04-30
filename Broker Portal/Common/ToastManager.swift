//
//  ToastManager.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

import UIKit

actor ToastManager {
    
    static let shared = ToastManager()
    
    private var isShowing = false
    
    func showToast(
        message: String,
        duration: TimeInterval = 2.0,
        font: UIFont = InterFontStyle.bold.with(size: 14),
        backgroundColor: UIColor = UIColor.HeaderGreenColor,
        textColor: UIColor = .AppWhiteColor
    ) async {
        // Ensure only one toast at a time
        if isShowing { return }
        isShowing = true
        
        await MainActor.run {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                Task { await self.dismissed() }
                return
            }
            
            let toastLabel = PaddingLabel()
            toastLabel.text = message
            toastLabel.font = font
            toastLabel.textColor = textColor
            toastLabel.backgroundColor = backgroundColor
            toastLabel.textAlignment = .center
            toastLabel.alpha = 0.0
            toastLabel.numberOfLines = 0
            toastLabel.layer.cornerRadius = 8
            toastLabel.clipsToBounds = true
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            
            window.addSubview(toastLabel)
            
            // Constraints: top with padding, horizontal margin 20, height adjusts with content
            NSLayoutConstraint.activate([
                toastLabel.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 20),
                toastLabel.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
                toastLabel.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20)
            ])
            
            // Animate in and out
            UIView.animate(withDuration: 0.3, animations: {
                toastLabel.alpha = 1.0
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    UIView.animate(withDuration: 0.3, animations: {
                        toastLabel.alpha = 0.0
                    }) { _ in
                        toastLabel.removeFromSuperview()
                        Task { await self.dismissed() }
                    }
                }
            }
        }
    }
    
    private func dismissed() {
        isShowing = false
    }
}

class PaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
