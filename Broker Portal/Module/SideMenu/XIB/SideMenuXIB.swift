//
//  SideMenuXIB.swift
//  Broker Portal
//
//  Created by Pankaj on 30/04/25.
//

import UIKit

class SideMenuXIB: UITableViewCell {

    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
