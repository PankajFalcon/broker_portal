//
//  StateValue.swift
//  Broker Portal
//
//  Created by Pankaj on 08/05/25.
//

struct DropDownModel :Codable{
    let label: String
    let value: String
    let disabled: Bool
    
    init(label: String, value: String, disabled: Bool = false) {
        self.label = label
        self.value = value
        self.disabled = disabled
    }
}

let userType: [DropDownModel] = [
    DropDownModel(label: "BROKER ADMIN", value: "51"),
    DropDownModel(label: "BROKER USER", value: "52")
]

let states: [DropDownModel] = [
    DropDownModel(label: "Alaska", value: "AK"),
    DropDownModel(label: "Alabama", value: "AL"),
    DropDownModel(label: "Arkansas", value: "AR"),
    DropDownModel(label: "Arizona", value: "AZ"),
    DropDownModel(label: "California", value: "CA"),
    DropDownModel(label: "CANADA", value: "CANADA"),
    DropDownModel(label: "Colorado", value: "CO"),
    DropDownModel(label: "Connecticut", value: "CT"),
    DropDownModel(label: "Washington DC", value: "DC"),
    DropDownModel(label: "Delaware", value: "DE"),
    DropDownModel(label: "Florida", value: "FL"),
    DropDownModel(label: "Georgia", value: "GA"),
    DropDownModel(label: "Hawaii", value: "HI"),
    DropDownModel(label: "Iowa", value: "IA"),
    DropDownModel(label: "Idaho", value: "ID"),
    DropDownModel(label: "Illinois", value: "IL"),
    DropDownModel(label: "Indiana", value: "IN"),
    DropDownModel(label: "Kansas", value: "KS"),
    DropDownModel(label: "Kentucky", value: "KY"),
    DropDownModel(label: "Louisiana", value: "LA"),
    DropDownModel(label: "Massachusetts", value: "MA"),
    DropDownModel(label: "Maryland", value: "MD"),
    DropDownModel(label: "Maine", value: "ME"),
    DropDownModel(label: "Michigan", value: "MI"),
    DropDownModel(label: "Minnesota", value: "MN"),
    DropDownModel(label: "Missouri", value: "MO"),
    DropDownModel(label: "Mississippi", value: "MS"),
    DropDownModel(label: "Montana", value: "MT"),
    DropDownModel(label: "North Carolina", value: "NC"),
    DropDownModel(label: "North Dakota", value: "ND"),
    DropDownModel(label: "Nebraska", value: "NE"),
    DropDownModel(label: "New Hampshire", value: "NH"),
    DropDownModel(label: "New Jersey", value: "NJ"),
    DropDownModel(label: "New Mexico", value: "NM"),
    DropDownModel(label: "Nevada", value: "NV"),
    DropDownModel(label: "New York", value: "NY"),
    DropDownModel(label: "Ohio", value: "OH"),
    DropDownModel(label: "Oklahoma", value: "OK"),
    DropDownModel(label: "Oregon", value: "OR"),
    DropDownModel(label: "Pennsylvania", value: "PA"),
    DropDownModel(label: "Rhode Island", value: "RI"),
    DropDownModel(label: "South Carolina", value: "SC"),
    DropDownModel(label: "South Dakota", value: "SD"),
    DropDownModel(label: "Tennessee", value: "TN"),
    DropDownModel(label: "Texas", value: "TX"),
    DropDownModel(label: "Utah", value: "UT"),
    DropDownModel(label: "Virginia", value: "VA"),
    DropDownModel(label: "Vermont", value: "VT"),
    DropDownModel(label: "Washington", value: "WA"),
    DropDownModel(label: "Wisconsin", value: "WI"),
    DropDownModel(label: "West Virginia", value: "WV"),
    DropDownModel(label: "Wyoming", value: "WY")
]
