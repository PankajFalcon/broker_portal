//
//  ActivityAndPolicyXIB.swift
//  Broker Portal
//
//  Created by Pankaj on 28/04/25.
//

import UIKit

class ActivityAndPolicyXIB: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblQuoteNo: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupValue(value:RecentActivityRecord){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
