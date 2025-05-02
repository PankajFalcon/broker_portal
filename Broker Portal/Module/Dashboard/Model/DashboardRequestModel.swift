//
//  DashboardRequestModel.swift
//  Broker Portal
//
//  Created by Pankaj on 28/04/25.
//

struct DashboardRequestModel: Codable {
    var page: Int? = 1
    var limit: Int? = 20
    var filter_flag: Int? = 1
    var underwriter: String? = ""
    var include_deleted: Int? = 0
    var submission_id: String? = ""
    var quote_desc: String? = ""
    var effective_date: String? = ""
    var policy_number: String? = ""
    var short_name: String? = ""
    var treaty_description: String? = ""
    var premium: String? = ""
    var status: String? = ""
    var submit_date: String? = ""
    var exp_date: String? = ""
    var cancellation_date: String? = ""
    var dot_number: String? = ""
    var insured_id: String? = ""
    var insured_name: String? = ""
    var lob: String? = ""
    var risk_company: String? = ""
    var claim_count: String? = ""
    var agency: String? = ""
    var status_id_int: String? = ""
    var treaty_id_int: String? = ""
    var products: String? = ""
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
