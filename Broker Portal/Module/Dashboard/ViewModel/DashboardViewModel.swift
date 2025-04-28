//
//  DashboardViewModel.swift
//  Broker Portal
//
//  Created by Pankaj on 28/04/25.
//

import Foundation

class DashboardViewModel{
    
    weak var view : DashboardVC?
    var model : DashboardRequestModel?
    
    init(view: DashboardVC? = nil) {
        self.view = view
    }
    
    func fetchActivitiesAndPolicy() {
        guard let view = self.view else { return }
        
        // Using Task to run both API calls concurrently
        Task {
            do {
                // Start both API calls concurrently
                async let recentActivityResponse = getRecentActivity()
                async let policyResponse = getPolicy()
                
                // Wait for both to finish
                let activityResponseData = try await recentActivityResponse
                let policyResponseData = try await policyResponse
                
                debugPrint( activityResponseData?.data?.records?.first?.submissionId ?? 0)
                debugPrint( policyResponseData?.data?.records?.first?.submissionId ?? 0)
                
            } catch {
                // Handle any errors that occur
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
    
    func getRecentActivity() async throws -> RecentActivityModel? {
        guard let url = APIConstants.recentActivity else { return nil }
        
        let model = await DashboardRequestModel.createModel()
        
        let response: RecentActivityModel = try await APIManagerHelper.shared.handleRequest(
            .postRequest(url: url, body: try model.toDictionaryExcludingEmptyStrings().data(), headers: [:]),
            responseType: RecentActivityModel.self
        )
        
        if response.status != 0 {
            return response // return the response on success
        } else {
            // Handle case where status is 0
            await ToastManager.shared.showToast(message: response.message ?? "Unknown error")
            return nil // or throw an error if needed
        }
    }
    
    func getPolicy() async throws -> RecentActivityModel? {
        guard let url = APIConstants.getPolicy else { return nil }
        
        let model = await DashboardRequestModel.createModel()
        
        let response: RecentActivityModel = try await APIManagerHelper.shared.handleRequest(
            .postRequest(url: url, body: try model.toDictionaryExcludingEmptyStrings().data(), headers: [:]),
            responseType: RecentActivityModel.self
        )
        
        if response.status != 0 {
            return response // return the response on success
        } else {
            await ToastManager.shared.showToast(message: response.message ?? "Unknown error")
            return nil // or throw an error if needed
        }
    }
    
}
