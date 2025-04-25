//
//  UIViewController.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import Foundation
import UIKit

// From inside any view controller with a navigation controller

//push(ProfileViewController.self, from: .main)
//
//// With configuration
//push(SettingsViewController.self, from: .settings) { vc in
//    vc.userID = "12345"
//    vc.isDarkModeEnabled = true
//}

public extension UIViewController {
    
    /// Push a view controller from storyboard onto the current navigation stack
    func push<T: UIViewController>(_ type: T.Type, from storyboard: AppStoryboard, setup: ((T) -> Void)? = nil) {
        let vc = T.instantiate(from: storyboard)
        setup?(vc)
        
        guard let navigationController = self.navigationController else {
            debugPrint("NavigationController not found. Make sure this view controller is embedded in a UINavigationController.")
            return
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    /// Present a view controller from storyboard onto the current navigation stack
    func present<T: UIViewController>(_ type: T.Type, from storyboard: AppStoryboard, setup: ((T) -> Void)? = nil) {
        let vc = T.instantiate(from: storyboard)
        setup?(vc)
        present(vc, animated: true)
    }
    
}

public extension UIViewController {
    
    //MARK: How to use
    //        configureNavigationBar(title: "Abc",leftImage: UIImage(named: "Vector"), leftAction:  {
    //            debugPrint("Tap")
    //        })
    
    /// Configure navigation bar with customizable left and right buttons (memory-safe)
    /// - Parameters:
    ///   - title: Title to display in the navigation bar
    ///   - leftTitle: Optional left button title
    ///   - leftImage: Optional left button image
    ///   - leftAction: Action closure for left button (default: pop)
    ///   - rightTitle: Optional right button title
    ///   - rightImage: Optional right button image
    ///   - rightAction: Action closure for right button
    func configureNavigationBar(
        title: String? = nil,
        leftTitle: String? = nil,
        leftImage: UIImage? = nil,
        leftAction: (() -> Void)? = nil,
        rightTitle: String? = nil,
        rightImage: UIImage? = nil,
        rightAction: (() -> Void)? = nil
    ) {
        self.title = title
        
        // Left Button
        if let leftAction = leftAction {
            let action = UIAction { [weak self] _ in
                guard self != nil else {return}
                leftAction()
            }
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: leftTitle,
                image: leftImage,
                primaryAction: action,
                menu: nil
            )
        } else if leftTitle != nil || leftImage != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: leftTitle,
                style: .plain,
                target: self,
                action: #selector(defaultBackAction)
            )
            navigationItem.leftBarButtonItem?.image = leftImage
        }
        
        // Right Button
        if let rightAction = rightAction {
            let action = UIAction { [weak self] _ in
                guard self != nil else {return}
                rightAction()
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: rightTitle,
                image: rightImage,
                primaryAction: action,
                menu: nil
            )
        } else if rightTitle != nil || rightImage != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: rightTitle,
                style: .plain,
                target: nil,
                action: nil
            )
            navigationItem.rightBarButtonItem?.image = rightImage
        }
    }
    
    // MARK: - Default Back Button Fallback
    
    @objc private func defaultBackAction() {
        navigationController?.popViewController(animated: true)
    }
}
