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
        .init(title: "First Name",param: .FirstName, isRequired: true, placeholder: "Eg: Johne"),
        .init(title: "Middle Name",param: .MiddleName ,isRequired: false, placeholder: "Eg: David"),
        .init(title: "Last Name",param: .LastName ,isRequired: true, placeholder: "Eg: Smith"),
        .init(title: "Address",param: .Address ,isRequired: false, placeholder: "Eg: 3555 Pennsylvania Avenue"),
        .init(title: "City",param: .City ,isRequired: false, placeholder: "Eg: Bluefield"),
        .init(title: "State",param: .State, isRequired: false, textFieldType: .dropdown, dropdownValue: states, placeholder: "Select..."),
        .init(title: "Zip Code",param: .Zipcode ,isRequired: true, placeholder: "Enter..."),
        .init(title: "Contact Number Office",param: .ContactOffice ,isRequired: false,keyboardType:.phone, placeholder: "Eg: (212) 555 4567"),
        .init(title: "Contact Number Mobile",param: .ContactMobile ,isRequired: false,keyboardType:.phone, placeholder: "Eg: (212) 555 4567"),
        .init(title: "User Type",param: .UserType ,isRequired: true, textFieldType: .dropdown, dropdownValue: userType, placeholder: "Select..."),
        .init(title: "Business Email",param: .Email ,isRequired: true, placeholder: "abc@example.com"),
        .init(title: "Password",param: .PasswordUser,errorMessage:ErrorMessages.invalidPassword.rawValue ,isRequired: true, placeholder: "********")
    ]
    
    func addAndUpdateUser(isEdit:Bool) async {
        guard
            let view = self.view,
            let url = await isEdit ? APIConstants.updateUser(self.view?.userDetails?.id ?? 0) : APIConstants.addUser
        else {
            Log.error("Invalid view or URL.")
            return
        }
               
        var params = await view.dictionaryFrom(
            array: userFields,
            keyPath: \AddUserUIModel.param,
            valuePath: \AddUserUIModel.value
        )
        
        params[ConstantApiParam.AgencyID] = await UserDefaultsManager.shared.getAgencyID()
        params["user_status"] = ""
        params["gender"] = "Male"
        params["default_user"] = "N"
        params["supervisor"] = NSNull()
        params["internal_user"] = 0
        params["entity_id"] = NSNull()
        
        if isEdit{
            params[ConstantParam.PasswordUser.rawValue] = "pwd@1234"
        }
        debugPrint(params)
        
        Task {
            do {
                let jsonData = try await APIManagerHelper.shared.convertIntoData(from: params)
                
                let response: AddUserResponseModel = try await APIManagerHelper.shared.handleRequest(
                    .postRequest(url: url, body: jsonData,method: isEdit ? .put : .post, headers: [:]),
                    responseType: AddUserResponseModel.self
                )
                
                if response.status != 0 {
                    // ✅ Handle success scenario
                    await ToastManager.shared.showToast(message: response.message ?? "User added successfully.")
                    // Optionally: notify delegate / close screen / reset form
                    await view.popView()
                } else {
                    // ❌ API reported failure
                    await ToastManager.shared.showToast(message: response.message ?? ErrorMessages.somethingWentWrong.rawValue)
                }
                
            } catch {
                // ❗ Handle networking/decoding errors
                await ToastManager.shared.showToast(message: error.localizedDescription)
                Log.error("Add user failed: \(error)")
            }
        }
    }
    
}

