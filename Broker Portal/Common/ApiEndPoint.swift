//
//  ApiEndPoint.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

import Foundation

//MARK: How to use

//static var posts: URL? { url("/posts") }
//static func post(_ id: Int) -> URL? { url("/posts/\(id)") }

enum APIConstants{
    
    static let baseURL = "https://futuristic-policy.dev.falconsystem.com"
    static let version = "/ams-v1"
    
    static var userlogin: URL? { url("/adminop/userlogin") }
    static var recentActivity: URL? { url("/quoteop/get_quotes_for_broker_recent_activity") }
    static var getPolicy: URL? { url("/quoteop/get-all-policy-data-paginated") }
    
    private static func url(_ path: String) -> URL? {
        URL(string: baseURL + version + path)
    }
}
