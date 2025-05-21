//
//  BrokerUserXIB.swift
//  Broker Portal
//
//  Created by Pankaj on 06/05/25.
//

import UIKit

class BrokerUserXIB: UITableViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblAgency: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(model:UsersListModel?){
        lblName.text = "\(model?.first_name ?? "") \(model?.last_name ?? "")"
        lblEmail.text = model?.email ?? ""
        lblState.text = model?.state ?? "N/A"
        lblAgency.text = "\(model?.agency_id ?? 0)"
        lblUserType.text = model?.user_type ?? ""
        
        if model?.user_status == .active{
            containerView.backgroundColor = .AppLightGrey.withAlphaComponent(0.08)
        }else{
            containerView.backgroundColor = .AppWhiteColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
