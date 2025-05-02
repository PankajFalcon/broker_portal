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
            leftAction: { self.popView() }
        )
        
        setupSearchTextField()
        
        Task{
            // Initial button setup
            await setupButtonStates(isActivitySelected: true)
        }
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
            Task{
                await self.refreshData()
            }
        }
    }
    
    private func refreshData() async {
        // Your API call or logic
        view.endEditing(true)
        tableView.endRefreshing()
        viewModel?.model?.page = 1
        if isActivity == true{
            await fetchActivities()
        }else{
            await fetchPolicy()
        }
        
    }
    
    private func setupSearchTextField() {
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtSearch.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let query = textField.text ?? ""
        
        debouncer.run { [weak self] in
            guard let self = self else { return }
            Task{
                await self.performSearch(with: query)
            }
        }
    }
    
    private func performSearch(with query: String) async {
        viewModel?.model?.page = 1
        if isActivity == true{
            await fetchActivities()
        }else{
            await fetchPolicy()
        }
    }
    
    // MARK: - Button Actions
    @IBAction func activityOnPress(_ sender: UIButton) {
        SideMenuManager.shared.toggleMenu()
//        Task{
//            await setupButtonStates(isActivitySelected: true)
//        }
    }
    
    @IBAction func policyOnPress(_ sender: UIButton) {
        Task{
            await setupButtonStates(isActivitySelected: false)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Updates button states for activity and policy
    private func setupButtonStates(isActivitySelected: Bool) async {
        // Activity button selected
        viewModel?.model?.page = 1
        if isActivitySelected == isActivity{
            return
        }
        isActivity = isActivitySelected
        if isActivitySelected {
            btnActivity.backgroundColor = .HeaderGreenColor
            btnPolicy.backgroundColor = .AppWhiteColor
            btnActivity.setTitleColor(.AppWhiteColor, for: .normal)
            btnPolicy.setTitleColor(.HeaderGreenColor, for: .normal)
            await fetchActivities()
        } else { // Policy button selected
            btnActivity.backgroundColor = .AppWhiteColor
            btnPolicy.backgroundColor = .HeaderGreenColor
            btnActivity.setTitleColor(.HeaderGreenColor, for: .normal)
            btnPolicy.setTitleColor(.AppWhiteColor, for: .normal)
            await fetchPolicy()
        }
    }
    
    /// Fetch recent activities asynchronously
    private func fetchActivities() async {
        guard let viewModel = viewModel else { return }
        self.isActivity = true
        Task {
            
            viewModel.model?.insured_name = txtSearch.trim()
            do {
                let response = try await viewModel.getRecentActivity()
                if viewModel.model?.page == 1 {
                    responseModel = response?.data?.records
                } else if let newRecords = response?.data?.records {
                    responseModel = (responseModel ?? []) + newRecords
                }
                
                if response?.data?.records?.count ?? 0 < viewModel.model?.limit ?? 0{
                    viewModel.isLoading = false
                }else{
                    viewModel.isLoading = true
                }
                
                self.tableView.refresh()
            } catch {
                // Handle error (e.g., show an alert)
                Log.error("Failed to fetch activities: \(error.localizedDescription)")
                self.responseModel?.removeAll()
                self.tableView.refresh()
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
    
    /// Fetch policy asynchronously
    private func fetchPolicy() async {
        guard let viewModel = viewModel else { return }
        self.isActivity = false
        Task {
            
            viewModel.model?.insured_name = txtSearch.trim()
            
            do {
                let response = try await viewModel.getPolicy()
                if viewModel.model?.page == 1 {
                    responseModel = response?.data?.records
                } else if let newRecords = response?.data?.records {
                    responseModel = (responseModel ?? []) + newRecords
                }
                if response?.data?.records?.count ?? 0 < viewModel.model?.limit ?? 0{
                    viewModel.isLoading = false
                }else{
                    viewModel.isLoading = true
                }
                tableView.setEmptyMessage(response?.message ?? "", self.responseModel?.count ?? 0)
                self.tableView.refresh()
            } catch {
                // Handle error (e.g., show an alert)
                Log.error("Failed to fetch policy: \(error.localizedDescription)")
                responseModel?.removeAll()
                tableView.setEmptyMessage(error.localizedDescription, self.responseModel?.count ?? 0)
                tableView.refresh()
                await ToastManager.shared.showToast(message: error.localizedDescription)
            }
        }
    }
}

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActivityAndPolicyXIB = tableView.dequeueReusableCell(for: indexPath)
        if let data = responseModel?[indexPath.row] {
            cell.setupValue(value: data)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel, viewModel.isLoading == true else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let threshold: CGFloat = 100
        
        if offsetY > contentHeight - scrollView.frame.height - threshold {
            // Copy reference to avoid conflict
            let currentPage = (viewModel.model?.page ?? 0) + 1
            
            Task { [weak self] in
                guard let self else { return }
                
                viewModel.isLoading = false // mark as loading
                viewModel.model?.page = currentPage
                
                if isActivity ?? false {
                    await fetchActivities()
                } else {
                    await fetchPolicy()
                }
            }
        }
    }
    
}
