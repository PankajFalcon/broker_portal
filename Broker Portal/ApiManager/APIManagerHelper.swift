//
//  APIManagerHelper.swift
//  WebService
//
//  Created by Pankaj on 18/02/25.
//

import Foundation

public class APIManagerHelper : @unchecked Sendable{
    
    public static let shared = APIManagerHelper()
    private let loaderManager = LoaderManager()
    
    private init() {} // Private constructor to enforce singleton pattern
    
    /// Generic function to handle API requests and decode response into a Codable model
    public func handleRequest<T: Codable>(
        _ request: APIRequest,
        responseType: T.Type,
        progress: ((APIRequest.File, Double) -> Void)? = nil
    ) async throws -> T {
        loaderManager.showLoadingWithDelay()
        let data = try await APIManager.shared.handleRequest(request, progress: progress)
        // After 1 second (API returns fast)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            loaderManager.hideLoading()
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError("Failed to decode response into \(T.self): \(error.localizedDescription)")
        }
    }
    
    /// Converts a dictionary into JSON `Data`, throwing an error if conversion fails
    public func convertIntoData(from parameters: [String: Any]) async throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            throw APIError.decodingError("Failed to convert parameters into JSON: \(error.localizedDescription)")
        }
    }
    
    /// Converts an `Encodable` model into JSON `Data`
    public func convertModelToData<T: Encodable>(_ model: T) async throws -> Data {
        do {
            return try JSONEncoder().encode(model)
        } catch {
            throw APIError.decodingError("Failed to encode model \(T.self) into JSON: \(error.localizedDescription)")
        }
    }
}
