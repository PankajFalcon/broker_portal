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
    private let debouncer = Debouncer(delay: 0.5)
    private var isActivity: Bool?
    private var responseModel: [RecentActivityRecord]?

    deinit{
        Log.debug("DashboardVC deinit")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = DashboardViewModel(view: self)
        viewModel?.model = DashboardRequestModel()

        configureNavigationBar(
            title: AppTitle.Dashboard.rawValue,
            leftImage: .menu,
            leftAction: { SideMenuManager.shared.toggleMenu() },
            isRightCustomImage: true
        )

        setupSearchTextField()
        setupTableView()

        Task { [weak self] in
            await self?.setupButtonStates(isActivitySelected: true)
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellType: ActivityAndPolicyXIB.self)

        tableView.addRefreshControl { [weak self] in
            Task {
                await self?.refreshData()
            }
        }
    }

    private func refreshData() async {
        view.endEditing(true)
        tableView.endRefreshing()
        viewModel?.model?.page = 1
        if isActivity == true {
            await fetchActivities()
        } else {
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
            Task { [weak self] in
                await self?.performSearch(with: query)
            }
        }
    }

    private func performSearch(with query: String) async {
        viewModel?.model?.page = 1
        if isActivity == true {
            await fetchActivities()
        } else {
            await fetchPolicy()
        }
    }

    // MARK: - Button Actions
    @IBAction func activityOnPress(_ sender: UIButton) {
        Task { [weak self] in
            await self?.setupButtonStates(isActivitySelected: true)
        }
    }

    @IBAction func policyOnPress(_ sender: UIButton) {
        Task { [weak self] in
            await self?.setupButtonStates(isActivitySelected: false)
        }
    }

    private func setupButtonStates(isActivitySelected: Bool) async {
        guard isActivity != isActivitySelected else { return }
        isActivity = isActivitySelected

        btnActivity.backgroundColor = isActivitySelected ? .HeaderGreenColor : .AppWhiteColor
        btnPolicy.backgroundColor = isActivitySelected ? .AppWhiteColor : .HeaderGreenColor

        btnActivity.setTitleColor(isActivitySelected ? .AppWhiteColor : .HeaderGreenColor, for: .normal)
        btnPolicy.setTitleColor(isActivitySelected ? .HeaderGreenColor : .AppWhiteColor, for: .normal)

        viewModel?.model?.page = 1
        if isActivitySelected {
            await fetchActivities()
        } else {
            await fetchPolicy()
        }
    }

    private func fetchActivities() async {
        guard let viewModel else { return }
        isActivity = true

        viewModel.model?.insured_name = txtSearch.trim()

        do {
            let response = try await viewModel.getRecentActivity()

            if viewModel.model?.page == 1 {
                responseModel = response?.data?.records
            } else if let newRecords = response?.data?.records {
                responseModel = (responseModel ?? []) + newRecords
            }

            viewModel.isLoading = (response?.data?.records?.count ?? 0) >= (viewModel.model?.limit ?? 0)

            tableView.setEmptyMessage("No recent activity found.", responseModel?.count ?? 0)
            tableView.refresh()

        } catch {
            Log.error("Failed to fetch activities: \(error.localizedDescription)")
            responseModel?.removeAll()
            tableView.refresh()
            await ToastManager.shared.showToast(message: error.localizedDescription)
        }
    }

    private func fetchPolicy() async {
        guard let viewModel else { return }
        isActivity = false

        viewModel.model?.insured_name = txtSearch.trim()

        do {
            let response = try await viewModel.getPolicy()

            if viewModel.model?.page == 1 {
                responseModel = response?.data?.records
            } else if let newRecords = response?.data?.records {
                responseModel = (responseModel ?? []) + newRecords
            }

            viewModel.isLoading = (response?.data?.records?.count ?? 0) >= (viewModel.model?.limit ?? 0)

            tableView.setEmptyMessage("No policy found.", responseModel?.count ?? 0)
            tableView.refresh()

        } catch {
            Log.error("Failed to fetch policy: \(error.localizedDescription)")
            responseModel?.removeAll()
            tableView.setEmptyMessage(error.localizedDescription, responseModel?.count ?? 0)
            tableView.refresh()
            await ToastManager.shared.showToast(message: error.localizedDescription)
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
