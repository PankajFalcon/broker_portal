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
    }
    
    func setupValue(value:RecentActivityRecord){
        lblStatus.text = value.status ?? ""
        lblPremium.text = value.premium ?? "$0.0"
        lblQuoteNo.text = "\(value.quoteId ?? 0)"
        lblCompanyName.text = value.insuredName ?? ""
        lblDate.text = value.submitDate ?? ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
