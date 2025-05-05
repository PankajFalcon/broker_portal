//
//  SelectAgencyVC.swift
//  Broker Portal
//
//  Created by Pankaj on 02/05/25.
//

import UIKit

class SelectAgencyVC: UIViewController {
    
    @IBOutlet weak var txtAgency: UITextField!
    
    private let agencyManager = InsuranceAgencyManager()
    private var agencies: [AgencyModelResponseData]? = nil
    let dropdown = DropdownView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            if let agencies = await agencyManager.getAgencies() {
                DispatchQueue.main.async {
                    self.agencies = agencies
                }
            } else {
                DispatchQueue.main.async {
                    // Handle empty or failed response
                    debugPrint("No agencies found")
                }
            }
        }
        
        txtAgency.inputView = UIView() // Disable keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(showDropdown))
        txtAgency.addGestureRecognizer(tap)
    }
    
    @objc func showDropdown() {
        let agencyName = self.agencies?.map{$0.name ?? ""} ?? []
        if !agencyName.isEmpty{
            dropdown.show(from: txtAgency, data: agencyName) { selected in
                self.txtAgency.text = selected
            }
        }
    }
    
    @IBAction func crossOnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveOnPress(_ sender: UIButton) {
        self.dismiss(animated: true) {
            Task {
                let object = self.agencies?.map{$0.name == self.txtAgency.text ?? ""}.first
                await UserDefaultsManager.shared.set(object, forKey: UserDefaultsKey.SelectedAgencies)
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = scene.delegate as? SceneDelegate {
                    await sceneDelegate.setRoot()
                }
            }
        }
    }
    
}
