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

enum AppTitle:String{
    case Dashboard = "Dashboard"
}

public extension UIViewController {
    
    /// Instantiate a view controller from a storyboard.
    /// - Parameters:
    ///   - storyboardName: The name of the storyboard file.
    ///   - identifier: The view controller's storyboard ID. If nil, the class name will be used.
    /// - Returns: An instantiated view controller of the expected type.
    static func instantiate<T: UIViewController>(fromStoryboard storyboardName: AppStoryboard, identifier: String? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let id = identifier ?? String(describing: T.self)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: id) as? T else {
            fatalError("❌ ViewController with identifier \(id) not found in \(storyboardName) storyboard.")
        }
        return viewController
    }
    
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
    
    func popView(){
        navigationController?.popViewController(animated: true)
    }
    
    /// Present a view controller from storyboard onto the current navigation stack
    func present<T: UIViewController>(_ type: T.Type, from storyboard: AppStoryboard, setup: ((T) -> Void)? = nil) {
        let vc = T.instantiate(from: storyboard)
        setup?(vc)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
}

extension UIViewController {
    
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
    
    func actionSheet(agencyID: Int) {
        var actions: [ActionSheetAction] = [
            .init(title: "User Profile", type: .default, handler: {
                debugPrint("User Profile tapped")
            })
        ]
        
        // Add "Change Agency" only if agencyID is 41
        if agencyID == 41 {
            actions.append(
                .init(title: "Change Agency", type: .default, handler: {
                    self.present(SelectAgencyVC.self, from: .main) { vc in
                        // Configure VC if needed
                    }
                })
            )
        }
        
        actions.append(contentsOf: [
            .init(title: "Logout", type: .destructive, handler: {
                print("Logout tapped")
            }),
            .init(title: "Cancel", type: .cancel, handler: nil)
        ])
        
        Task{
            ActionSheetHelper.showActionSheet(
                on: self,
                title: agencyID == 41 ? "\(await UserDefaultsManager.shared.fatchCurentUser()?.firstName ?? "") \(await UserDefaultsManager.shared.fatchCurentUser()?.lastName ?? "")\n\(await UserDefaultsManager.shared.getSelectedAgency()?.name ?? "")" : "\(await UserDefaultsManager.shared.fatchCurentUser()?.firstName ?? "") \(await UserDefaultsManager.shared.fatchCurentUser()?.lastName ?? "")",
                message: "Please select an action",
                actions: actions,
                sourceView: self.view
            )
        }
    }
    
    
    func configureNavigationBar(
        title: String? = nil,
        leftTitle: String? = nil,
        leftImage: Icon? = nil,
        leftCustomImage: UIImage? = nil,
        leftAction: (() -> Void)? = nil,
        rightTitle: String? = nil,
        rightImage: Icon? = nil,
        rightCustomImage: UIImage? = nil,
        isRightCustomImage:Bool? = false,
        rightAction: (() -> Void)? = nil
    ) {
        self.title = title
        
        navigationItem.leftBarButtonItem = createBarButtonItem(
            title: leftTitle,
            image: leftImage?.image,
            customImage: leftCustomImage,
            action: leftAction
        )
        
        Task{
            navigationItem.rightBarButtonItem = createBarButtonItem(
                title: rightTitle,
                image: rightImage?.image,
                customImage: isRightCustomImage == true ? rightCustomImage == nil ? await UserImageGenerator.generateProfileImage(imageURLString: UserDefaultsManager.shared.fatchCurentUser()?.image ?? "", firstName: UserDefaultsManager.shared.fatchCurentUser()?.firstName ?? "", lastName: UserDefaultsManager.shared.fatchCurentUser()?.lastName ?? "") : rightCustomImage : nil,
                action: rightAction
            )
        }
    }
    
    private func createBarButtonItem(
        title: String?,
        image: UIImage?,
        customImage: UIImage?,
        action: (() -> Void)?
    ) -> UIBarButtonItem? {
        if let customImage = customImage {
            let button = UIButton(type: .custom)
            button.setImage(customImage, for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            button.imageView?.contentMode = .scaleAspectFill
            button.layer.cornerRadius = 20
            button.layer.borderColor = UIColor.headerGreen.cgColor
            button.layer.borderWidth = 1
            button.clipsToBounds = true
            button.isUserInteractionEnabled = true
            
            if action != nil {
                button.addAction(UIAction { _ in
                    //                     action()
                    Task{
                        await self.actionSheet(agencyID: UserDefaultsManager.shared.fatchCurentUser()?.userTypeId ?? 0)
                    }
                }, for: .touchUpInside)
            }
            
            return UIBarButtonItem(customView: button)
        } else if let image = image {
            if let action = action {
                return UIBarButtonItem(
                    title: title,
                    image: image,
                    primaryAction: UIAction { _ in
                        action()
                    },
                    menu: nil
                )
            } else {
                let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(defaultBackAction))
                barButton.image = image
                return barButton
            }
        } else if let title = title {
            let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(defaultBackAction))
            return barButton
        }
        
        return nil
    }
    
    // MARK: - Default Back Button Fallback
    
    @objc private func defaultBackAction() {
        navigationController?.popViewController(animated: true)
    }
}
