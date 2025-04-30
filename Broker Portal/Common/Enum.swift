//
//  Enum.swift
//  Broker Portal
//
//  Created by Pankaj on 29/04/25.
//

import UIKit

enum Icon {
    case back

    var image: UIImage? {
        switch self {
        case .back:
            return UIImage(named: "ic_back") // Make sure this name matches your asset catalog
        }
    }
}

enum SideMenuIcon{
    case home
    case policies
    case products
    case agency
    case contact
    var image: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "ic_home_white")
        case .policies:
            return UIImage(named: "ic_polices_white")
        case .products:
            return UIImage(named: "ic_product_white")
        case .agency:
            return UIImage(named: "ic_agency_admin_white")
        case .contact:
            return UIImage(named: "ic_contact")
        }
    }
}

