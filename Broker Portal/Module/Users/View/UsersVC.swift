//
//  UsersVC.swift
//  Broker Portal
//
//  Created by Pankaj on 06/05/25.
//

import UIKit

class UsersVC: UIViewController {
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel : UsersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = UsersViewModel(view: self)
        setupTableView()
        
        // Configure navigation bar
        configureNavigationBar(
            title: AppTitle.Users.rawValue,leftImage: .back,rightImage: .add) { [weak self] in
                self?.push(AddUserVC.self, from: .admin)
            }
        
        setupSearchTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task{
            await viewModel?.fetchBrokerUserList()
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(cellType: BrokerUserXIB.self)
        tableView.addRefreshControl {
            Task{
                await self.refreshData()
            }
        }
    }
    
    private func refreshData() async {
        // Your API call or logic
        view.endEditing(true)
        tableView.endRefreshing()
        Task{
            await viewModel?.fetchBrokerUserList()
        }
    }
    
    private func setupSearchTextField() {
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtSearch.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let query = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        
        guard let viewModel = viewModel,
              let data = viewModel.model?.data else {
            return
        }
        
        if query.isEmpty {
            viewModel.filterModel = data
        } else {
            viewModel.filterModel = data.filter { item in
                let firstNameMatch = item.first_name?.lowercased().contains(query) ?? false
                let lastNameMatch = item.last_name?.lowercased().contains(query) ?? false
                let emailMatch = item.email?.lowercased().contains(query) ?? false
                let agencyIdMatch = String(item.agency_id ?? 0).contains(query)
                let userTypeMatch = String(item.user_type?.lowercased() ?? "").contains(query)
                
                return firstNameMatch || lastNameMatch || emailMatch || agencyIdMatch || userTypeMatch
            }
        }
        
        tableView.refresh()
    }
    
    @objc func activeOnPress(sender:UIButton) {
        Task{
            await viewModel?.activeOrInactive(index: sender.tag)
        }
    }
    
    @objc func changePasswordOnPress(sender:UIButton){
        
    }
    
    @objc func editOnPress(sender:UIButton){
        if let indexData = viewModel?.filterModel?[sender.tag]{
            push(AddUserVC.self, from: .admin) { [weak self] vc in
                guard self != nil else { return }
                vc.userDetails = indexData
            }
        }
    }
    
}

extension UsersVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filterModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BrokerUserXIB = tableView.dequeueReusableCell(for: indexPath)
        
        cell.btnEdit.tag = indexPath.row
        cell.btnChangePassword.tag = indexPath.row
        cell.btnActive.tag = indexPath.row
        
        Task{
            cell.btnEdit.isHidden = await UserDefaultsManager.shared.isAdmin()
            cell.btnActive.isHidden = await UserDefaultsManager.shared.isAdmin()
            cell.btnChangePassword.isHidden = await UserDefaultsManager.shared.isAdmin()
        }
        
        cell.btnEdit.addTarget(self, action: #selector(editOnPress(sender:)), for: .touchUpInside)
        cell.btnActive.addTarget(self, action: #selector(activeOnPress(sender:)), for: .touchUpInside)
        cell.btnChangePassword.addTarget(self, action: #selector(changePasswordOnPress(sender:)), for: .touchUpInside)
        
        cell.setupData(model: viewModel?.filterModel?[indexPath.row])
        
        return cell
    }
    
}
