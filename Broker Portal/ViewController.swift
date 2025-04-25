//
//  ViewController.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit
//import FalconAPIFramework

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    private let loaderManager = LoaderManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func validate(_ sender: UIButton) {
        //        self.validate()
//        self.postApi()
    }
    
    func validate() {
        guard let text = emailTextField.text, !text.isEmpty else {
            emailTextField.showError(message: "Email cannot be empty.")
            return
        }
        emailTextField.removeError()
    }
//    
//    private func fetchData() {
//        guard let url = APIConstants.posts else { return }
//        
//        Task {
//            do {
//                let response: [YourModel] = try await APIManagerHelper.shared.handleRequest(.getRequest(url: url, headers: nil), responseType: [YourModel].self)
//                print("API Response:", response)
//            } catch {
//                print("API Error:", error)
//            }
//        }
//    }
//    
//    private func postApi(){
//        guard let url = APIConstants.posts else { return }
//        
//        
//        Task {
//            do {
//                let response: [YourModel] = try await APIManagerHelper.shared.handleRequest(.getRequest(url: url, headers: [:]), responseType: [YourModel].self)
//                print("API Response:", response)
//            } catch {
//                print("API Error:", error)
//            }
//        }
//    }
    
}

struct YourModel: Codable {
    let id: Int?
    let title: String?
    let name : String?
}
