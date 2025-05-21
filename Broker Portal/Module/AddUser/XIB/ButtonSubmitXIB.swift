//
//  ButtonSubmitXIB.swift
//  Broker Portal
//
//  Created by Pankaj on 08/05/25.
//

import UIKit

class ButtonSubmitXIB: UIView {

    @IBOutlet weak var btnSubmit: UIButton!
    
    // Load from nib
        class func instantiateFromNib() -> ButtonSubmitXIB {
            let nib = UINib(nibName: "ButtonSubmitXIB", bundle: nil)
            guard let view = nib.instantiate(withOwner: nil, options: nil).first as? ButtonSubmitXIB else {
                fatalError("Could not load TableFooterView from nib.")
            }
            return view
        }

}
