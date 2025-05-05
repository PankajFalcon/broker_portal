//
//  AgencyModel.swift
//  Broker Portal
//
//  Created by Pankaj on 05/05/25.
//

import Foundation

// MARK: - Root Response
struct AgencyModelResponse: Codable {
    let message: String?
    let status: Int?
    let statusCode: Int?
    let data: [AgencyModelResponseData]?
}

// MARK: - Insurance Agency
struct AgencyModelResponseData: Codable {
    let id: Int?
    let idName: String?
    let name: String?
    let phone: String?
    let city: String?
    let badCredit: String?
    let image: String?
    let agencyID: Int?
    let producerContactEmail: String?
    let producerPhone: String?
    let producerBindConfirmationEmail: String?
    let producerEndorsementsEmail: String?
    let producerCancellationEmail: String?
    let state: String?
    let address: String?
    let zip: String?
    let fax: String?
    let claimsEmail: String?
    let uw: Int?
    let repr: String?
    let fedID: String?
    let financeCompany: Int?
    let isActive: Int?
    let openItem: String?

    enum CodingKeys: String, CodingKey {
        case id
        case idName = "id_name"
        case image = "image"
        case name, phone, city
        case badCredit = "bad_credit"
        case agencyID = "agency_id"
        case producerContactEmail = "producer_contact_email"
        case producerPhone = "producer_phone"
        case producerBindConfirmationEmail = "producer_bind_confirmation_email"
        case producerEndorsementsEmail = "producer_endorsements_email"
        case producerCancellationEmail = "producer_cancellation_email"
        case state, address, zip, fax
        case claimsEmail = "claims_email"
        case uw, repr
        case fedID = "fed_id"
        case financeCompany = "finance_company"
        case isActive = "is_active"
        case openItem = "open_item"
    }
}
