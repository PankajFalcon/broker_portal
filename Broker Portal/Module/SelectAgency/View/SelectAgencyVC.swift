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
    private var agencies: [AgencyModelResponseData] = []
    private var filterName: [String] = []
    
    var saveAgency: (() -> Void)?
    
    private let dropdown = DropdownView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            if let fetchedAgencies = await agencyManager.getAgencies() {
                await MainActor.run {
                    self.agencies = fetchedAgencies
                }
            } else {
                Log.error("No agencies found")
            }
        }
        
        txtAgency.inputView = UIView() // Disable keyboard
        txtAgency.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtAgency.addTarget(self, action: #selector(textFieldDidBegin(_:)), for: .editingDidBegin)
        
    }
    
    @objc private func textFieldDidBegin(_ textField: UITextField) {
        let agencyNames = agencies.map { $0.name ?? "" }
        showDropdown(agencyNames: agencyNames)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        let agencyNames = agencies.map { $0.name ?? "" }
        filterName = agencyNames.filter { $0.lowercased().contains(searchText) }
        debugPrint(filterName)
        showDropdown(agencyNames: filterName)
    }
    
    private func showDropdown(agencyNames: [String]) {
        guard !agencyNames.isEmpty else { return }
        dropdown.show(from: txtAgency, data: agencyNames) { [weak self] selected in
            self?.txtAgency.text = selected
        }
    }
    
    @IBAction func crossOnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveOnPress(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            Task {
                if let selectedAgency = self.agencies.first(where: { $0.name == self.txtAgency.text }) {
                    await UserDefaultsManager.shared.set(selectedAgency, forKey: UserDefaultsKey.SelectedAgencies)
                }
                self.saveAgency?()
            }
        }
    }
}

