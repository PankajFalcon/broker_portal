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
            ConstantParam.UserID: view.txtEmail.text ?? "",
            ConstantParam.Password: view.txtPassword.text ?? ""
        ]
        
        Task {
            do {
                let response: LoginModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: try param.data(), headers: [:]),
                    responseType: LoginModel.self
                )
                if response.status != 0 {
                    if await response.decodedUser?.userTypeId ?? 0 == 41{
                        await self.view?.present(SelectAgencyVC.self, from: .main) { vc in

                        }
                    }else{
                        await UserDefaultsManager.shared.set(response, forKey: UserDefaultsKey.LoginResponse)
//                        await self.view?.push(DashboardVC.self, from: .dashboard)
                        if let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let sceneDelegate = await scene.delegate as? SceneDelegate {
                            
                            Task { @MainActor in
                                await sceneDelegate.setRoot()
                            }
                        }

                    }
                } else {
                    await ToastManager.shared.showToast(message: response.message ?? "")
                }
            } catch {
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}
