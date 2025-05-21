//
//  SceneDelegate.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let newWindow = UIWindow(windowScene: windowScene)
        self.window = newWindow
        
        Task { @MainActor in
            await setRoot()
        }
    }
    
    private func createSideMenu(rootVC: UIViewController) {
        let menuVC : MenuViewController = MenuViewController.instantiate(fromStoryboard: .main,identifier: .MenuViewController)
        
        guard let window = self.window else { return }
        
        SideMenuManager.shared.setup(menu: menuVC, root: rootVC, in: window)
    }
    
    func setRoot() async {
        // Fetch and clean access token
        let loginModel = await UserDefaultsManager.shared.get(LoginModel.self, forKey: UserDefaultsKey.LoginResponse)
        let accessToken = loginModel?.accessToken?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Determine root VC based on login state
        guard !accessToken.isEmpty else {
            createSideMenu(rootVC: LoginVC.instantiate(fromStoryboard: .main,identifier: .LoginVC))
            return
        }
        
        let userTypeId = await UserDefaultsManager.shared.fatchCurentUser()?.userTypeId ?? 0
        let agencyID = await UserDefaultsManager.shared.getAgencyID()
        
        if userTypeId == 41 && agencyID == 0 {
            await UserDefaultsManager.shared.clearAll()
            createSideMenu(rootVC: LoginVC.instantiate(fromStoryboard: .main,identifier: .LoginVC))
            return
        }
        
        createSideMenu(rootVC: DashboardVC.instantiate(fromStoryboard: .dashboard,identifier: .DashboardVC))
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

