//
//  UsersModel.swift
//  Broker Portal
//
//  Created by Pankaj on 06/05/25.
//

import Foundation
import Foundation

// MARK: - Root Response Model
struct UsersModel: Codable {
    let message: String?
    let status: Int?
    let statusCode: Int?
    let data: [UsersListModel]?
}

enum UserStatus: String, Codable {
    case active = "Active"
    case inactive = "Inactive"
    case unknown

    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "active":
            self = .active
        case "inactive":
            self = .inactive
        default:
            self = .unknown
        }
    }

    var isActive: Bool { self == .active }
    var isInactive: Bool { self == .inactive }
}

// MARK: - User Model
struct UsersListModel: Codable {
    let id: Int?
    let first_name: String?
    let middle_name: String?
    let last_name: String?
    let address: String?
    let city: String?
    let state: String?
    let zipcode: String?
    let contact_number_office: String?
    let contact_number_mobile: String?
    let email: String?
    let user_type_id: Int?
    let gender: String?
    var user_status: UserStatus?
    let agency_id : Int?
    let user_type : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case first_name
        case middle_name
        case last_name
        case address
        case city
        case state
        case agency_id
        case zipcode
        case contact_number_office
        case contact_number_mobile
        case email
        case user_type_id
        case gender
        case user_type
        case user_status
    }
}
