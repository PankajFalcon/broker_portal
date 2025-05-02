//
//  RecentActivityModel.swift
//  Broker Portal
//
//  Created by Pankaj on 28/04/25.
//

import Foundation


struct RecentActivityModel: Codable {
    let message: String?
    let status: Int?
    let statusCode: Int?
    let data: RecentActivityModelData?
}

struct RecentActivityModelData: Codable {
    let records: [RecentActivityRecord]?
    let totalCount: Int?
    let page: Int?
    let limit: Int?
    let hasNextPage: Bool?
    let hasPrevPage: Bool?
    let nextPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case records
        case totalCount = "total_count"
        case page
        case limit
        case hasNextPage = "has_next_page"
        case hasPrevPage = "has_prev_page"
        case nextPage = "next_page"
    }
}

struct RecentActivityRecord: Codable {
    let submissionId: Int?
    let policyNumber: String?
    let lockedStatus: Int?
    let lockedBy: Int?
    let shortName: String?
    let agencyId: Int?
    let insuredName: String?
    let insuredGaragingState: String?
    let isActive: Int?
    let insuredOtherName1: String?
    let insuredOtherName2: String?
    let insuredId: String?
    let quoteDesc: String?
    let expDate: String?
    let dotNumber: String?
    let effectiveDate: String?
    let submitDate: String?
    let quoteId: Int?
    let lobId: Int?
    let claimCount: Int?
    let isBrokerQuote: Int?
    let premium: String?
    let lob: String?
    let riskCompany: String?
    let underwriterId: Int?
    let underwriter: String?
    let agencyAbbr: String?
    let agency: String?
    let status: String?
    let duplicates: String?
    let cancellationDate: String?
    let isPersonalAuto: Int?
    let applicationTypeId: Int?
    let product: String?
    let treatyDescription: String?
    let treatyId: Int?
    let statusId: Int?
    let isBrokerPortal: Int?

    enum CodingKeys: String, CodingKey {
        case submissionId = "submission_id"
        case policyNumber = "policy_number"
        case lockedStatus = "locked_status"
        case lockedBy = "locked_by"
        case shortName = "short_name"
        case agencyId = "agency_id"
        case insuredName = "insured_name"
        case insuredGaragingState = "insured_garaging_state"
        case isActive = "is_active"
        case insuredOtherName1 = "insured_other_name_1"
        case insuredOtherName2 = "insured_other_name_2"
        case insuredId = "insured_id"
        case quoteDesc = "quote_desc"
        case expDate = "exp_date"
        case dotNumber = "dot_number"
        case effectiveDate = "effective_date"
        case submitDate = "submit_date"
        case quoteId = "quote_id"
        case lobId = "lob_id"
        case claimCount = "claim_count"
        case isBrokerQuote = "is_broker_quote"
        case premium
        case lob
        case riskCompany = "risk_company"
        case underwriterId = "underwriter_id"
        case underwriter
        case agencyAbbr = "agency_abbr"
        case agency
        case status
        case duplicates
        case cancellationDate = "cancellation_date"
        case isPersonalAuto = "is_personal_auto"
        case applicationTypeId = "application_type_id"
        case product
        case treatyDescription = "treaty_description"
        case treatyId = "treaty_id"
        case statusId = "status_id"
        case isBrokerPortal = "is_broker_portal"
    }
}
