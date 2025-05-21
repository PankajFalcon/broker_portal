//
//  TextfieldXIB.swift
//  Broker Portal
//
//  Created by Pankaj on 08/05/25.
//

import UIKit

class TextfieldXIB: UITableViewCell {
    
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureTitle(_ title: String, isRequired: Bool) {
        let baseColor = lblTitle.textColor ?? .label
        let baseFont = lblTitle.font ?? UIFont.systemFont(ofSize: 16)
        
        // Base title
        let baseString = NSMutableAttributedString(
            string: title,
            attributes: [
                .foregroundColor: baseColor,
                .font: baseFont
            ]
        )
        
        if isRequired {
            // Red asterisk with custom font size (e.g., 18)
            let redStar = NSAttributedString(
                string: " *",
                attributes: [
                    .foregroundColor: UIColor.red,
                    .font: UIFont.systemFont(ofSize: 18)
                ]
            )
            baseString.append(redStar)
        }
        
        lblTitle.attributedText = baseString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
