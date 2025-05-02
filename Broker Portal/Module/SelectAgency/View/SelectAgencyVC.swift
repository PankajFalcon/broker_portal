//
//  SelectAgencyVC.swift
//  Broker Portal
//
//  Created by Pankaj on 02/05/25.
//

import UIKit

class SelectAgencyVC: UIViewController {
    
    @IBOutlet weak var txtAgency: UITextField!
    
    let dropdown = DropdownView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtAgency.inputView = UIView() // Disable keyboard
            let tap = UITapGestureRecognizer(target: self, action: #selector(showDropdown))
        txtAgency.addGestureRecognizer(tap)
        }

        @objc func showDropdown() {
            dropdown.show(from: txtAgency, data: ["Option A", "Option B", "Option C"]) { selected in
                self.txtAgency.text = selected
            }
        }
    
    @IBAction func crossOnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveOnPress(_ sender: UIButton) {
        dropdown.show(from: sender, data: ["Option 1", "Option 2", "Option 3"]) { selected in
            sender.setTitle(selected, for: .normal)
        }
    }
    
    func setupDropdownTextField(_ textField: UITextField, options: [String]) {
        // Prevent keyboard input
        textField.inputView = UIView() // empty view disables keyboard
        
        // Add tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTextFieldTap(_:)))
        textField.addGestureRecognizer(tap)
        textField.isUserInteractionEnabled = true
        
        // Store options in accessibilityHint temporarily
        textField.accessibilityHint = options.joined(separator: "|")
    }
    
    @objc func handleTextFieldTap(_ gesture: UITapGestureRecognizer) {
        guard let textField = gesture.view as? UITextField else { return }
        let options = textField.accessibilityHint?.components(separatedBy: "|") ?? []
        
        dropdown.show(from: textField, data: options) { selected in
            textField.text = selected
        }
    }
    
}
