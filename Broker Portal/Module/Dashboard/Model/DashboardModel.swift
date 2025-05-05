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
    
    /// New date value from `effectiveDate` string
    //    let effectiveDateObject: Date?
    let effectiveStringObject: String?
    
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        submissionId = try container.decodeIfPresent(Int.self, forKey: .submissionId)
        policyNumber = try container.decodeIfPresent(String.self, forKey: .policyNumber)
        lockedStatus = try container.decodeIfPresent(Int.self, forKey: .lockedStatus)
        lockedBy = try container.decodeIfPresent(Int.self, forKey: .lockedBy)
        shortName = try container.decodeIfPresent(String.self, forKey: .shortName)
        agencyId = try container.decodeIfPresent(Int.self, forKey: .agencyId)
        insuredName = try container.decodeIfPresent(String.self, forKey: .insuredName)
        insuredGaragingState = try container.decodeIfPresent(String.self, forKey: .insuredGaragingState)
        isActive = try container.decodeIfPresent(Int.self, forKey: .isActive)
        insuredOtherName1 = try container.decodeIfPresent(String.self, forKey: .insuredOtherName1)
        insuredOtherName2 = try container.decodeIfPresent(String.self, forKey: .insuredOtherName2)
        insuredId = try container.decodeIfPresent(String.self, forKey: .insuredId)
        quoteDesc = try container.decodeIfPresent(String.self, forKey: .quoteDesc)
        expDate = try container.decodeIfPresent(String.self, forKey: .expDate)
        dotNumber = try container.decodeIfPresent(String.self, forKey: .dotNumber)
        effectiveDate = try container.decodeIfPresent(String.self, forKey: .effectiveDate)
        submitDate = try container.decodeIfPresent(String.self, forKey: .submitDate)
        quoteId = try container.decodeIfPresent(Int.self, forKey: .quoteId)
        lobId = try container.decodeIfPresent(Int.self, forKey: .lobId)
        claimCount = try container.decodeIfPresent(Int.self, forKey: .claimCount)
        isBrokerQuote = try container.decodeIfPresent(Int.self, forKey: .isBrokerQuote)
        premium = try container.decodeIfPresent(String.self, forKey: .premium)
        lob = try container.decodeIfPresent(String.self, forKey: .lob)
        riskCompany = try container.decodeIfPresent(String.self, forKey: .riskCompany)
        underwriterId = try container.decodeIfPresent(Int.self, forKey: .underwriterId)
        underwriter = try container.decodeIfPresent(String.self, forKey: .underwriter)
        agencyAbbr = try container.decodeIfPresent(String.self, forKey: .agencyAbbr)
        agency = try container.decodeIfPresent(String.self, forKey: .agency)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        duplicates = try container.decodeIfPresent(String.self, forKey: .duplicates)
        cancellationDate = try container.decodeIfPresent(String.self, forKey: .cancellationDate)
        isPersonalAuto = try container.decodeIfPresent(Int.self, forKey: .isPersonalAuto)
        applicationTypeId = try container.decodeIfPresent(Int.self, forKey: .applicationTypeId)
        product = try container.decodeIfPresent(String.self, forKey: .product)
        treatyDescription = try container.decodeIfPresent(String.self, forKey: .treatyDescription)
        treatyId = try container.decodeIfPresent(Int.self, forKey: .treatyId)
        statusId = try container.decodeIfPresent(Int.self, forKey: .statusId)
        isBrokerPortal = try container.decodeIfPresent(Int.self, forKey: .isBrokerPortal)
        
        // Convert effectiveDate string to Date
        if let dateString = effectiveDate {
            effectiveStringObject = DateUtils.convertDateFormat(dateString: dateString, inputFormat: .yyyyMMdd, outputFormat: .ddMMyyyy)
        } else {
            effectiveStringObject = nil
        }
        
        //        // Convert effectiveDate string to Date
        //        if let dateString = effectiveDate {
        //            effectiveDateObject = DateUtils.convertToDate(dateString: dateString, inputFormat: .fullDateTime)
        //        } else {
        //            effectiveDateObject = nil
        //        }
    }
}

