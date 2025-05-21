//
//  AddUserUIModel.swift
//  Broker Portal
//
//  Created by Pankaj on 08/05/25.
//

import Foundation
import UIKit

// Enum for specifying types of text fields
enum TextFieldType: String, Codable {
    case text
    case number
    case dropdown
    case date
    case email
    case password
}

// Enum to map string values to keyboard types
enum KeyboardType: String, Codable {  // Ensure `Codable` for Decodable compliance
    case email = "email"
    case number = "number"
    case phone = "phone"
    case defaultType = "default"
    
    // Convert to actual UIKeyboardType for text fields
    func toUIKeyboardType() -> UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .number:
            return .numberPad
        case .phone:
            return .phonePad
        case .defaultType:
            return .default
        }
    }
}

// Struct to model the user input fields for the form
struct AddUserUIModel: Codable {
    var title: String?
    var value: String?
    var errorMessage: String?
    var param: ConstantParam
    var isRequired: Bool?
    var keyboardType: KeyboardType?
    var textFieldType: TextFieldType?
    var dropdownValue: [DropDownModel]?
    var isEnable: Bool?
    var placeholder: String?
    var isHidden: Bool?
    var id: Int?
    var parentID: Int?
    
    // Default initializer with sensible defaults
    init(
        title: String = "",
        value: String = "",
        param: ConstantParam,
        errorMessage: String = ErrorMessages.requiredField.rawValue,
        isRequired: Bool = false,
        keyboardType: KeyboardType = .defaultType,
        textFieldType: TextFieldType = .text,
        dropdownValue: [DropDownModel] = [],
        isEnable: Bool = true,
        placeholder: String = "",
        isHidden: Bool = false,
        id: Int = 0,
        parentID: Int = 0
    ) {
        self.title = title
        self.value = value
        self.param = param
        self.errorMessage = errorMessage
        self.isRequired = isRequired
        self.keyboardType = keyboardType
        self.textFieldType = textFieldType
        self.dropdownValue = dropdownValue
        self.isEnable = isEnable
        self.placeholder = placeholder
        self.isHidden = isHidden
        self.id = id
        self.parentID = parentID
    }
}
