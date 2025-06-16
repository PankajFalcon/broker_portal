//
//  LoginViewModel.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

import UIKit

class LoginViewModel {
    
    private weak var view: LoginVC? // ✅ weak to avoid memory leaks
    
    init(view: LoginVC? = nil) {
        self.view = view
    }
    
    func loginApiCall() {
        guard let view = self.view else { return }
        guard let url = APIConstants.userlogin else { return }
        
        let param = [
            ConstantApiParam.UserID: view.txtEmail.text ?? "",
            ConstantApiParam.Password: view.txtPassword.text ?? ""
        ]
        
        Task {
            do {
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: param)
                let response: LoginModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData, headers: [:]),
                    responseType: LoginModel.self
                )
                
                if response.status != 0 {
                    await UserDefaultsManager.shared.set(response, forKey: UserDefaultsKey.LoginResponse)
                    
                    if await UserDefaultsManager.shared.isAdmin() {
                        await self.view?.present(SelectAgencyVC.self, from: .main) { vc in
                            vc.saveAgency = {
                                Task {
                                    if let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let sceneDelegate = await scene.delegate as? SceneDelegate {
                                        await sceneDelegate.setRoot()
                                    }
                                }
                            }
                        }
                    } else {
                        if let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let sceneDelegate = await scene.delegate as? SceneDelegate {
                            await sceneDelegate.setRoot()
                        }
                    }
                } else {
                    await ToastManager.shared.showToast(message: response.message)
                }
            } catch {
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
    
}
