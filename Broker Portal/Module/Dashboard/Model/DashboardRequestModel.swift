//
//  DashboardRequestModel.swift
//  Broker Portal
//
//  Created by Pankaj on 28/04/25.
//

struct DashboardRequestModel: Codable {
    var page: Int? = 1
    var limit: Int? = 10
    var filter_flag: Int? = 1
    var underwriter: String? = nil
    var include_deleted: Int? = 0
    var submission_id: String? = nil
    var quote_desc: String? = nil
    var effective_date: String? = nil
    var policy_number: String? = nil
    var short_name: String? = nil
    var treaty_description: String? = nil
    var premium: String? = nil
    var status: String? = nil
    var submit_date: String? = nil
    var exp_date: String? = nil
    var cancellation_date: String? = nil
    var dot_number: String? = nil
    var insured_id: String? = nil
    var insured_name: String? = nil
    var lob: String? = nil
    var risk_company: String? = nil
    var claim_count: String? = nil
    var agency: String? = nil
    var status_id_int: String? = nil
    var treaty_id_int: String? = nil
    var products: String? = nil
    var agency_id: Int?
    
    // Function to load the agency_id asynchronously
    static func loadAgencyId() async -> Int {
        return await UserDefaultsManager.shared.get(LoginModel.self, forKey: UserDefaultsKey.LoginResponse)?.decodedUser?.agencyId ?? 0
    }
    
    // Function to create an instance of the model asynchronously
    static func createModel() async -> DashboardRequestModel {
        let agencyId = await loadAgencyId()
        return DashboardRequestModel(agency_id: agencyId)
    }
    
    func toDictionaryExcludingEmptyStrings() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            guard let key = child.label else { continue }
            
            if let value = child.value as? String {
                if !value.isEmpty {
                    dict[key] = value
                }
            } else {
                dict[key] = child.value
            }
        }
        
        return dict
    }
    
}
