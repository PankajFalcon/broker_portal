//
//  Data.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

import Foundation

extension Data {
    func toDictionary() throws -> [String: Any] {
        let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
        guard let dict = jsonObject as? [String: Any] else {
            throw NSError(domain: "Invalid JSON format", code: 1001, userInfo: nil)
        }
        return dict
    }
}
