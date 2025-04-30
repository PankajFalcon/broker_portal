//
//  ErrorMessages.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import Foundation

enum Log {
    static func error(_ message: String, error: Error? = nil,
                      file: String = #fileID,
                      function: String = #function,
                      line: Int = #line) {
        var output = "\n🛑 🛑 🛑 🛑"
        output += "\nFile: \(file)"
        output += "\nFunction: \(function)"
        output += "\nLine: \(line)"
        output += "\nMessage: \(message)"
        if let error = error {
            output += "\nError: \(error)"
        }
        output += "\n🛑 🛑 🛑 🛑"
        debugPrint(output)
    }
}



enum ErrorMessages: String {
    case invalidEmail = "Enter a valid email address."
    case invalidPassword = "Password must be at least 8 characters, include uppercase, lowercase, and a number."
    case requiredField = "This field is required"
    case passwordRequired = "Password cannot be empty."
    case emailRequired = "Email cannot be empty."
}

