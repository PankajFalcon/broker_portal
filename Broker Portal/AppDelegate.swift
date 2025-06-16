//
//  AppDelegate.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        KeyboardManager.shared.enable()
        
        // Set custom appearance for UITextField and UITextView
        UITextField.appearance().tintColor = .LableTittleColor
        UITextView.appearance().tintColor = .LableTittleColor
        // PasteBlocker.disablePasteGlobally()
        
        // Perform async initialization of APIManager and ensure no retain cycles
        Task { [weak self] in
            guard self != nil else { return } // Capture self weakly to avoid retain cycle
            
            // Initialize APIManager
            await APIManager.initializeShared()
            Log.error("✅ APIManager is ready")
            
            // Now it's safe to use APIManager.shared.handleRequest()
            // You can make your first API call here if needed, for example:
            // let response = await APIManager.shared.handleRequest(...)
        }
        
        // Return true to indicate successful launch
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}
