//
//  SelectAgencyViewModel.swift
//  Broker Portal
//
//  Created by Pankaj on 05/05/25.
//

import Foundation

actor InsuranceAgencyManager {
    
    private var agencies: [AgencyModelResponseData]? = nil
    
    // MARK: - Public Method
    func getAgencies() async -> [AgencyModelResponseData]? {
        if let cached = agencies, !cached.isEmpty {
            // Return cached and refresh in background
            Task.detached(priority: .background) { [weak self] in
                guard let self else { return }
                _ = await self.fetchAndUpdateAgencies()
            }
            return cached
        } else {
            // No cache, fetch and return directly
            return await fetchAndUpdateAgencies()
        }
    }
    
    // MARK: - Private Method to Fetch and Update
    private func fetchAndUpdateAgencies() async -> [AgencyModelResponseData]? {
        let agency = await UserDefaultsManager.shared.get([AgencyModelResponseData].self, forKey: UserDefaultsKey.Agencies)
        if agency?.isEmpty == true || agency == nil{
            do {
                let newAgencies = try await fetchAgenciesFromAPI()
                self.agencies = newAgencies
                await UserDefaultsManager.shared.set(newAgencies, forKey: UserDefaultsKey.Agencies)
                return newAgencies
            } catch {
                Log.debug("❌ API fetch failed: \(error.localizedDescription)")
                return agencies // return current (even if nil)
            }
        }else{
            return agency
        }
    }
    
    // MARK: - API Call
    private func fetchAgenciesFromAPI() async throws -> [AgencyModelResponseData] {
        guard let url = APIConstants.brokerList else {
            throw URLError(.badURL)
        }
        
        do {
            let response: AgencyModelResponse = try await APIManagerHelper.shared.handleRequest(
                .getRequest(url: url, headers: [:]),isloaderHide: agencies?.isEmpty == true ? true : false,
                responseType: AgencyModelResponse.self
            )
            
            if response.status != 0 {
                return response.data ?? []
            } else {
                await ToastManager.shared.showToast(message: response.message)
                return []
            }
        } catch {
            await ToastManager.shared.showToast(message: error.localizedDescription)
            throw error
        }
    }
}
