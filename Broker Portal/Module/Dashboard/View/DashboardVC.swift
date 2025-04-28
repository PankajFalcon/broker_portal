//
//  DashboardVC.swift
//  Broker Portal
//
//  Created by Pankaj on 28/04/25.
//

import UIKit

class DashboardVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnPolicy: UIButton!
    @IBOutlet weak var btnActivity: UIButton!
    
    // MARK: - Properties
    private var viewModel: DashboardViewModel?
    private let debouncer = Debouncer(delay: 0.5) // 0.5 seconds delay
    private var isActivity : Bool?
    
    var responseModel : [RecentActivityRecord]?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize ViewModel
        viewModel = DashboardViewModel(view: self)
        viewModel?.model = DashboardRequestModel()
        
        // Configure navigation bar
        configureNavigationBar(
            title: AppTitle.Dashboard.rawValue,
            leftImage: UIImage(named: "Vector"),
            leftAction: { self.popView() }
        )
        
        setupSearchTextField()
        
        // Initial button setup
        setupButtonStates(isActivitySelected: true)
        
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellType: ActivityAndPolicyXIB.self)
        tableView.addRefreshControl {
            self.refreshData()
        }
    }
    
    private func refreshData() {
        // Your API call or logic
        view.endEditing(true)
        if isActivity == true{
            fetchActivities()
        }else{
            fetchPolicy()
        }
        
        // Once done:
        tableView.endRefreshing()
    }
    
    private func setupSearchTextField() {
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtSearch.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let query = textField.text ?? ""
        
        debouncer.run { [weak self] in
            guard let self = self else { return }
            self.performSearch(with: query)
        }
    }
    
    private func performSearch(with query: String) {
        // Your API call or local search logic here
        print("Searching for: \(query)")
        view.endEditing(true)
        responseModel?.removeAll()
        if isActivity == true{
            fetchActivities()
        }else{
            fetchPolicy()
        }
    }
    
    // MARK: - Button Actions
    @IBAction func activityOnPress(_ sender: UIButton) {
        setupButtonStates(isActivitySelected: true)
    }
    
    @IBAction func policyOnPress(_ sender: UIButton) {
        setupButtonStates(isActivitySelected: false)
    }
    
    // MARK: - Helper Methods
    
    /// Updates button states for activity and policy
    private func setupButtonStates(isActivitySelected: Bool) {
        // Activity button selected
        if isActivitySelected {
            btnActivity.backgroundColor = .HeaderGreenColor
            btnPolicy.backgroundColor = .AppWhiteColor
            btnActivity.setTitleColor(.AppWhiteColor, for: .normal)
            btnPolicy.setTitleColor(.HeaderGreenColor, for: .normal)
            fetchActivities()
        } else { // Policy button selected
            btnActivity.backgroundColor = .AppWhiteColor
            btnPolicy.backgroundColor = .HeaderGreenColor
            btnActivity.setTitleColor(.HeaderGreenColor, for: .normal)
            btnPolicy.setTitleColor(.AppWhiteColor, for: .normal)
            fetchPolicy()
        }
    }
    
    /// Fetch recent activities asynchronously
    private func fetchActivities() {
        guard let viewModel = viewModel else { return }
        self.isActivity = true
        Task {
            // Reset page and limit for new fetch
            viewModel.model?.page = 1
            viewModel.model?.limit = 10
            viewModel.model?.insured_name = txtSearch.trim()
            do {
                let response = try await viewModel.getRecentActivity()
                responseModel = response?.data?.records
                self.tableView.refresh()
            } catch {
                // Handle error (e.g., show an alert)
                debugPrint("Failed to fetch activities: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetch policy asynchronously
    private func fetchPolicy() {
        guard let viewModel = viewModel else { return }
        self.isActivity = false
        Task {
            // Reset page and limit for new fetch
            viewModel.model?.page = 1
            viewModel.model?.limit = 10
            viewModel.model?.insured_name = txtSearch.trim()
            
            do {
                let response = try await viewModel.getPolicy()
                responseModel = response?.data?.records
                self.tableView.refresh()
            } catch {
                // Handle error (e.g., show an alert)
                debugPrint("Failed to fetch policy: \(error.localizedDescription)")
            }
        }
    }
}

extension DashboardVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActivityAndPolicyXIB = tableView.dequeueReusableCell(for: indexPath)
        if let indexData = responseModel?[indexPath.row] {
            cell.setupValue(value: indexData)
        }
        return cell
    }
    
}
