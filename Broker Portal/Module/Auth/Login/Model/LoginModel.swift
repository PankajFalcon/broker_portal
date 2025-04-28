//
//  LoginModel.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

import Foundation

struct LoginModel: Codable {
    let status: Int?
    var accessToken: String?
    var refreshToken: String?
    let user: String?
    let agency: String?
    let additionalAccess: String?
    let message: String?
    let accountLocked: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
        case agency
        case message
        case accountLocked = "account_locked"
        case additionalAccess = "additional_access"
    }
    
    /// Computed property that automatically decrypts and parses the user token
    var decodedUser: UserModel? {
        get async {
            guard let user = user else { return nil }
            
            // Perform the decryption asynchronously
            let decrypted = await AESDecryptor.decryptCBC(base64EncodedString: user)
            
            // Parse the decrypted data
            let model = parseUser(from: decrypted ?? "")
            
            return model
        }
    }
    
}

struct ApplicationProfile: Codable {
    let trucking: Bool
    let propertyCasuality: Bool
    
    enum CodingKeys: String, CodingKey {
        case trucking
        case propertyCasuality = "property_casuality"
    }
}

struct UserModel: Codable {
    let userId: Int?
    let usertype: String?
    let userTypeId: Int?
    let firstName: String?
    let lastName: String?
    let address: String?
    let city: String?
    let state: String?
    let zipcode: String?
    let contactNumberOffice: String?
    let contactNumberMobile: String?
    let email: String?
    let isAllowedToChat: String?
    let agencyId: Int?
    let userStatus: String?
    let additionalAccess: [String]?
    let ticketProfile: [String]?
    let applicationProfile: ApplicationProfile
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case usertype
        case userTypeId = "user_type_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case address, city, state, zipcode
        case contactNumberOffice = "contact_number_office"
        case contactNumberMobile = "contact_number_mobile"
        case email
        case isAllowedToChat = "is_allowed_to_chat"
        case agencyId = "agency_id"
        case userStatus = "user_status"
        case additionalAccess = "additional_access"
        case ticketProfile = "ticket_profile"
        case applicationProfile = "application_profile"
    }
}

func parseUser(from decryptedString: String) -> UserModel? {
    guard let data = decryptedString.data(using: .utf8) else { return nil }
    let decoder = JSONDecoder()
    do {
        let user = try decoder.decode(UserModel.self, from: data)
        return user
    } catch {
        print("Failed to decode user: \(error)")
        return nil
    }
}
