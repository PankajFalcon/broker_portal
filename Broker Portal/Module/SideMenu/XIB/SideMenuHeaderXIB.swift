//
//  SideMenuHeaderXIB.swift
//  Broker Portal
//
//  Created by Pankaj on 30/04/25.
//

import UIKit

class SideMenuHeaderXIB: UITableViewHeaderFooterView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var btnTap: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
