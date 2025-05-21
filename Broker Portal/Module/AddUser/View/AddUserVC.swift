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
        let modelDict: [String: String] = Dictionary(
            uniqueKeysWithValues: mirror.children.compactMap {
                guard let key = $0.label else { return nil }
                let value = unwrap($0.value)
                print("🔑 Key: \(key), 🧾 Value: \(value)") // 👈 Debug Print
                return (key, value)
            }
        )
        
        return uiModels.map { uiModel in
            var updated = uiModel
            updated.value = modelDict[uiModel.param.rawValue] ?? ""
            return updated
        }
    }
    
    func unwrap(_ any: Any) -> String {
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
        let result = areAllRequiredValuesPresent(
            in: viewModel?.userFields ?? [],
            valuePath: \.value,
            isRequiredPath: \.isRequired
        )
        
        if result {
            // Use async if viewModel's addUser() is an async operation
            Task {
                await viewModel?.addAndUpdateUser(isEdit: self.userDetails != nil)
            }
        } else {
            checkValidation = true
            tableView.reloadData() // Prefer reloadData for full refresh
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
        
        // Set value based on textFieldType
        switch indexData.textFieldType {
        case .dropdown:
            cell.txtField.rightImage = Icon.dropDown.image ??  UIImage()
            cell.txtField.text = indexData.dropdownValue?.first(where: { $0.value == indexData.value })?.label
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
            guard self != nil else { return }
            self?.viewModel?.userFields[txtAgency.tag].value = self?.viewModel?.userFields[txtAgency.tag].dropdownValue?.filter({$0.label == selected}).first?.value
            self?.tableView.refresh()
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
