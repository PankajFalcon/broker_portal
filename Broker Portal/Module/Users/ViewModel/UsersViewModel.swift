//
//  UsersViewModel.swift
//  Broker Portal
//
//  Created by Pankaj on 06/05/25.
//

import Foundation

class UsersViewModel{
    
    private weak var view: UsersVC? // ✅ weak to avoid memory leaks
    var model : UsersModel?
    var filterModel : [UsersListModel]?
    
    init(view: UsersVC? = nil) {
        self.view = view
    }
    
    func fetchBrokerUserList() async {
        
        guard let url = APIConstants.brokerUserList(await UserDefaultsManager.shared.getAgencyID()) else { return }
        
        Task {
            do {
                let response: UsersModel = try await APIManagerHelper.shared.handleRequest(
                    .getRequest(url: url, headers: nil),
                    responseType: UsersModel.self
                )
                
                if response.status != 0 {
                    self.model = response
                    self.filterModel = response.data ?? []
                    await self.view?.tableView.refresh()
                    await self.view?.tableView.setEmptyMessage(ErrorMessages.nouserfound.rawValue, self.model?.data?.count ?? 0)
                } else {
                    await self.view?.tableView.setEmptyMessage(response.message ?? "", self.model?.data?.count ?? 0)
                    await ToastManager.shared.showToast(message: response.message)
                }
            } catch {
                await self.view?.tableView.setEmptyMessage(error.localizedDescription, self.model?.data?.count ?? 0)
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
    
    func activeOrInactive(index:Int) async {
        guard
            let view = self.view,
            let url = APIConstants.updateUser(self.filterModel?[index].id ?? 0)
        else {
            Log.error("Invalid view or URL.")
            return
        }
        
        var params = self.filterModel?[index].toDictionary() ?? [:]
        
        params[ConstantApiParam.AgencyID] = await UserDefaultsManager.shared.getAgencyID()
        params["user_status"] = self.filterModel?[index].user_status == .active ? "Inactive" : "Active"
        params["gender"] = "Male"
        params["default_user"] = "N"
        params["supervisor"] = NSNull()
        params["internal_user"] = 0
        params["entity_id"] = NSNull()
        params[ConstantParam.PasswordUser.rawValue] = "pwd@1234"
        params.removeValue(forKey: "id")
        params.removeValue(forKey:"user_type")
        Log.debug(params)
        
        Task {
            do {
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: params)
                
                let response: AddUserResponseModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData,method: .put, headers: [:]),
                    responseType: AddUserResponseModel.self
                )
                
                if response.status != 0 {
                    // ✅ Handle success scenario
                    await ToastManager.shared.showToast(message: response.message)
                    //self.filterModel?[index].user_status = self.filterModel?[index].user_status == .active ? .inactive : .active
                    await view.tableView.refresh()
                } else {
                    // ❌ API reported failure
                    await ToastManager.shared.showToast(message: response.message)
                }
                
            } catch {
                // ❗ Handle networking/decoding errors
                await ToastManager.shared.showToast(message: error.localizedDescription)
                Log.error("Add user failed: \(error)")
            }
        }
    }
}
