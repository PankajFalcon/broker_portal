//
//  UserDefaultsManager.swift
//  Broker Portal
//
//  Created by Pankaj on 24/04/25.
//

import Foundation

struct UserDefaultsKey{
    static let LoginResponse = "loginResponse"
    static let Agencies = "Agencies"
    static let SelectedAgencies = "SelectedAgencies"
}

actor UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Save
    func set<T: Encodable>(_ value: T, forKey key: String) async {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }
    
    func set<T>(_ value: T, forKey key: String) async {
        defaults.set(value, forKey: key)
    }
    
    // MARK: - Get
    func get<T: Decodable>(_ type: T.Type, forKey key: String) async -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func get<T>(_ type: T.Type, forKey key: String) async -> T? {
        return defaults.value(forKey: key) as? T
    }
    
    // MARK: - Remove
    func remove(forKey key: String) async {
        defaults.removeObject(forKey: key)
    }
    
    // MARK: - Clear All
    func clearAll() async {
        await LoginModel.userCache.clear()
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    func getSelectedAgency() async -> AgencyModelResponseData?{
        return await UserDefaultsManager.shared.get(AgencyModelResponseData.self, forKey: UserDefaultsKey.SelectedAgencies)
    }
    
    func fatchCurentUser() async -> UserModel?{
        return await UserDefaultsManager.shared.get(LoginModel.self, forKey: UserDefaultsKey.LoginResponse)?.decodedUser
    }
    
    func getAgencyID() async -> Int{
        let selectedAgency = await UserDefaultsManager.shared.getSelectedAgency()
        let currentUser = await UserDefaultsManager.shared.fatchCurentUser()
        
        let agencyID = selectedAgency?.agencyID ?? currentUser?.agencyId ?? 0
        return agencyID
    }
    
}
