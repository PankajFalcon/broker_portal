//
//  AddUserViewModel.swift
//  Broker Portal
//
//  Created by Pankaj on 08/05/25.
//

import Foundation

class AddUserViewModel {
    
    private weak var view: AddUserVC?
    
    init(view: AddUserVC? = nil) {
        self.view = view
    }
    
    var userFields: [AddUserUIModel] = [
        .init(title: ConstantTitle.FirstName,param: .FirstName, isRequired: true, placeholder: ConstantPlaceholderValue.Eg_Johne),
        .init(title: ConstantTitle.MiddleName,param: .MiddleName ,isRequired: false, placeholder: ConstantPlaceholderValue.Eg_David),
        .init(title: ConstantTitle.LastName,param: .LastName ,isRequired: true, placeholder: ConstantPlaceholderValue.Eg_David),
        .init(title: ConstantTitle.Address,param: .Address ,isRequired: false, placeholder: ConstantPlaceholderValue.Eg_Address),
        .init(title: ConstantTitle.City,param: .City ,isRequired: false, placeholder: ConstantPlaceholderValue.Eg_City),
        .init(title: ConstantTitle.State,param: .State, isRequired: false, textFieldType: .dropdown, dropdownValue: states, placeholder: ConstantPlaceholderValue.Select),
        .init(title: ConstantTitle.Zipcode,param: .Zipcode ,isRequired: true, placeholder: ConstantPlaceholderValue.Enter),
        .init(title: ConstantTitle.ContactNumberOffice,param: .ContactOffice ,isRequired: false,keyboardType:.phone, placeholder: ConstantPlaceholderValue.Phone),
        .init(title: ConstantTitle.ContactNumberMobile,param: .ContactMobile ,isRequired: false,keyboardType:.phone, placeholder: ConstantPlaceholderValue.Phone),
        .init(title: ConstantTitle.UserType,param: .UserType ,isRequired: true, textFieldType: .dropdown, dropdownValue: userType, placeholder: ConstantPlaceholderValue.Select),
        .init(title: ConstantTitle.BusinessEmail,param: .Email ,isRequired: true, placeholder: ConstantPlaceholderValue.Eg_Email),
        .init(title: ConstantTitle.Password,param: .PasswordUser,errorMessage:ErrorMessages.invalidPassword.rawValue ,isRequired: true, placeholder: ConstantPlaceholderValue.Eg_Passowrd)
    ]
    
    func addAndUpdateUser(isEdit:Bool) async {
        guard
            let view = self.view,
            let url = await isEdit ? APIConstants.updateUser(self.view?.userDetails?.id ?? 0) : APIConstants.addUser
        else {
            Log.error(ErrorMessages.invalidURL.rawValue)
            return
        }
        
        var params = await view.dictionaryFrom(
            array: userFields,
            keyPath: \AddUserUIModel.param,
            valuePath: \AddUserUIModel.value
        )
        
        params[ConstantApiParam.AgencyID] = await UserDefaultsManager.shared.getAgencyID()
        params["user_status"] = await view.userDetails?.user_status == .active ? UserStatus.active.rawValue : UserStatus.inactive.rawValue
        params["gender"] = "Male"
        params["default_user"] = "N"
        params["supervisor"] = NSNull()
        params["internal_user"] = 0
        params["entity_id"] = NSNull()
        
        if isEdit{
            params[ConstantParam.PasswordUser.rawValue] = "pwd@1234"
        }
        Log.debug(params)
        
        Task {
            do {
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: params)
                
                let response: AddUserResponseModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData,method: isEdit ? .put : .post, headers: [:]),
                    responseType: AddUserResponseModel.self
                )
                
                if response.status != 0 {
                    // ✅ Handle success scenario
                    await ToastManager.shared.showToast(message: response.message)
                    // Optionally: notify delegate / close screen / reset form
                    await view.popView()
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
