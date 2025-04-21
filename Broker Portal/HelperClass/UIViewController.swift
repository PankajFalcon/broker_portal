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
