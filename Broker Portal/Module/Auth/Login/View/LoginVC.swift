//
//  LoginVC.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

import UIKit

// MARK: - Login View Controller

class LoginVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var btnLogin: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    // MARK: - Properties
    
    private var viewModel: LoginViewModel!
    
    // MARK: - Lifecycle Methods
    
    @IBOutlet weak var stepBar: ChevronProgressBar!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        viewModel = LoginViewModel(view: self)
        
    }
    
    // MARK: - Setup
    
    private func setupView() {
        txtEmail.text = "ashishverma@falconsystem.com"
        txtPassword.text = "Test@1234s"
        txtEmail.font = InterFontStyle.medium.with(size: 14)
        txtPassword.font = InterFontStyle.medium.with(size: 14)
    }
    
    // MARK: - IBActions
    
    @IBAction private func loginOnPress(_ sender: UIButton) {
        guard validateInputs() else { return }
        viewModel.loginApiCall()
    }
    
    // MARK: - Validation
    
    private func validateInputs() -> Bool {
        var isValid = true
        
        // Validate email
        if let email = txtEmail.text, email.isEmpty {
            txtEmail.showError(message: ErrorMessages.emailRequired.rawValue)
            isValid = false
        } else if let email = txtEmail.text, !Validator.isValidEmail(email) {
            txtEmail.showError(message: ErrorMessages.invalidEmail.rawValue)
            isValid = false
        } else {
            txtEmail.removeError()
        }
        
        // Validate password
        if let password = txtPassword.text, password.isEmpty {
            txtPassword.showError(message: ErrorMessages.passwordRequired.rawValue)
            isValid = false
        } else if let password = txtPassword.text, !Validator.isValidPassword(password) {
            txtPassword.showError(message: ErrorMessages.invalidPassword.rawValue)
            isValid = false
        } else {
            txtPassword.removeError()
        }
        
        return isValid
    }
}
