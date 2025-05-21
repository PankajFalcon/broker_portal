//
//  ConstantParam.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

enum ConstantParam:String, Codable{
    case UserID = "user_id"
    case Password = "password"
    case FirstName = "first_name"
    case MiddleName = "middle_name"
    case LastName = "last_name"
    case Address = "address"
    case State = "state"
    case City = "city"
    case Zipcode = "zipcode"
    case ContactOffice = "contact_number_office"
    case ContactMobile = "contact_number_mobile"
    case Email = "email"
    case PasswordUser = "pwd"
    case UserType = "user_type_id"
    case Id = "id"
}

struct ConstantApiParam{
    static let UserID = "user_id"
    static let Password = "password"
    static let AgencyID = "agency_id"
    static let Email = "email"
    static let Business_Email = "Business Email"
}
