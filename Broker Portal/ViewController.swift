//
//  ViewController.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func validate(_ sender: UIButton) {
        self.validate()
    }
    
    func validate() {
        guard let text = emailTextField.text, !text.isEmpty else {
            emailTextField.showError(message: "Email cannot be empty.")
            return
        }
        
        emailTextField.removeError() // call this to reset UI if valid
    }


}

