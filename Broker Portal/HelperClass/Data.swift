//
//  Data.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

import Foundation

extension Data {
    func dataToDictionary() throws -> [String: Any] {
        let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
        guard let dict = jsonObject as? [String: Any] else {
            throw NSError(domain: "Invalid JSON format", code: 1001, userInfo: nil)
        }
        return dict
    }
}

extension Encodable {
    func toDictionary(usingSnakeCase: Bool = true) -> [String: Any]? {
        do {
            let encoder = JSONEncoder()
            if usingSnakeCase {
                encoder.keyEncodingStrategy = .convertToSnakeCase
            }

            let data = try encoder.encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

            return jsonObject as? [String: Any]
        } catch {
            Log.error("❌ Failed to convert to dictionary: \(error)")
            return nil
        }
    }
}
