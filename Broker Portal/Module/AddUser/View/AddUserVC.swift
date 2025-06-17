//
//  AddUserVC.swift
//  Broker Portal
//
//  Created by Pankaj on 08/05/25.
//

import UIKit

class AddUserVC: UIViewController {
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: AddUserViewModel?
    var userDetails : UsersListModel?
    private let dropdown = DropdownView()
    private var checkValidation = false
    
    deinit {
        Log.debug("AddUserVC deinitialized")
        viewModel = nil
        userDetails = nil
        viewModel?.userFields.removeAll()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddUserViewModel(view: self)
        
        if let userDetails = self.userDetails{
            self.viewModel?.userFields = self.updateUIModels(self.viewModel?.userFields ?? [], with: userDetails)
            self.viewModel?.userFields.removeLast()
        }
        
        // Configure navigation bar
        configureNavigationBar(title: AppTitle.UserDetails.rawValue, leftImage: .back)
        setupTableView()
    }
    
    //MARK: This Code Combile Array
    func updateUIModels<T>(
        _ uiModels: [AddUserUIModel],
        with model: T
    ) -> [AddUserUIModel] {
        let mirror = Mirror(reflecting: model)
        
        // Create a dictionary of model properties
        var modelDict: [String: String] = [:]
        
        for child in mirror.children {
            guard let key = child.label else { continue }
            var value = unwrap(child.value)
            
            if key == ConstantApiParam.State,
               let dropdownItem = viewModel?.userFields
                .first(where: { $0.param.rawValue == key })?
                .dropdownValue?
                .first(where: { $0.value == value || $0.label == value }) {
                value = dropdownItem.value
            }
            
            Log.error("🔑 Key: \(key), 🧾 Value: \(value)") // Optional debug log
            modelDict[key] = value
        }
        
        // Update UI models using the dictionary
        return uiModels.map { uiModel in
            var updated = uiModel
            updated.value = modelDict[uiModel.param.rawValue] ?? ""
            return updated
        }
    }
    
    private func unwrap(_ any: Any) -> String {
        let mirror = Mirror(reflecting: any)
        if mirror.displayStyle == .optional {
            if let child = mirror.children.first {
                return "\(child.value)"
            } else {
                return ""
            }
        } else {
            return "\(any)"
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(cellType: TextfieldXIB.self)
    }
    
    @IBAction func submitOnPress(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let userFields = viewModel?.userFields else { return }
        
        if let missingIndex = areAllRequiredValuesPresent(
            in: userFields,
            valuePath: \.value,
            isRequiredPath: \.isRequired
        ) {
            checkValidation = true
            tableView.reloadData()
            
            Task {
                await MainActor.run {
                    let indexPath = IndexPath(row: missingIndex, section: 0)
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                }
            }
            
        } else {
            Task { [weak self] in
                guard let self else { return }
                await self.viewModel?.addAndUpdateUser(isEdit: self.userDetails != nil)
            }
        }
    }
    
}

extension AddUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.userFields.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TextfieldXIB = tableView.dequeueReusableCell(for: indexPath)
        
        guard let indexData = viewModel?.userFields[indexPath.row] else { return cell }
        
        // Configure title and placeholder
        cell.configureTitle(indexData.title ?? "", isRequired: indexData.isRequired ?? false)
        cell.txtField.placeholder = indexData.placeholder
        cell.txtField.keyboardType = indexData.keyboardType?.toUIKeyboardType() ?? .default
        cell.txtField.tag = indexPath.row
        cell.txtField.delegate = self
        
        //MARK: Set value based on textFieldType
        switch indexData.textFieldType {
        case .dropdown:
            cell.txtField.rightImage = Icon.dropDown.image ??  UIImage()
            cell.txtField.text = indexData.dropdownValue?.first(where: { $0.value == indexData.value || $0.label == indexData.value})?.label
        default:
            cell.txtField.rightImage = nil
            cell.txtField.text = indexData.value ?? ""
        }
        
        // Handle validation
        if checkValidation, indexData.isRequired == true {
            let trimmedValue = indexData.value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let title = indexData.title?.capitalized ?? ""
            
            cell.lblErrorMessage.text = {
                switch title {
                case ConstantApiParam.Password.capitalized:
                    if trimmedValue.isEmpty {
                        return ErrorMessages.requiredField.rawValue
                    } else if !Validator.isValidPassword(trimmedValue) {
                        return indexData.errorMessage
                    }
                case ConstantApiParam.Business_Email.capitalized:
                    if trimmedValue.isEmpty {
                        return ErrorMessages.requiredField.rawValue
                    } else if !Validator.isValidEmail(trimmedValue) {
                        return ErrorMessages.invalidEmail.rawValue
                    }
                default:
                    if trimmedValue.isEmpty {
                        return indexData.errorMessage
                    }
                }
                return ""
            }()
        } else {
            cell.lblErrorMessage.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension AddUserVC {
    
    private func showDropdown(txtAgency: UITextField, dropDownValue: [String]) {
        guard !dropDownValue.isEmpty else { return }
        view.endEditing(true)
        
        dropdown.show(from: txtAgency, data: dropDownValue) { [weak self] selected in
            guard let self,
                  txtAgency.tag < self.viewModel?.userFields.count ?? 0,
                  let dropdownOption = self.viewModel?.userFields[txtAgency.tag].dropdownValue?.first(where: { $0.label == selected }) else { return }

            self.viewModel?.userFields[txtAgency.tag].value = dropdownOption.value
            self.tableView.refresh()
        }
    }

}

extension AddUserVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let index = viewModel?.userFields[textField.tag] else { return true }
        
        if index.textFieldType == .dropdown {
            showDropdown(txtAgency: textField, dropDownValue: index.dropdownValue?.map { $0.label } ?? [])
            return false // Prevent keyboard from showing
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let index = textField.tag as Int?, index < viewModel?.userFields.count ?? 0 else { return }
        viewModel?.userFields[index].value = text
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let indexData = viewModel?.userFields[textField.tag] else { return true }
        
        if indexData.keyboardType == .phone{
            guard let currentText = textField.text,
                  let textRange = Range(range, in: currentText)
            else {
                return false
            }
            
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            let digits = updatedText.filter(\.isNumber)
            let formatted = Validator.format(digits)
            
            textField.text = formatted
            
            // Move cursor to end (optional)
            let endPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
            return false // prevent default system behavior
        }else{
            return true
        }
    }
    
}
