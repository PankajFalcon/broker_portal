//
//  SideMenu.swift
//  Broker Portal
//
//  Created by Pankaj on 30/04/25.
//

import UIKit

//MARK: How to use
//Call this function direct -> SideMenuManager.shared.toggleMenu()

// MARK: - Menu View Controller

struct SideMenuItem {
    let title: String
    let image: UIImage
    let subtitle: [String]
}

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: SideMenuItemType)
}

enum SideMenuItemType {
    case general, professional, trucking, other
}

@MainActor
final class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: MenuViewControllerDelegate?
    
    var selectedIndex : Int?
    
    private let sideMenuItems: [SideMenuItem] = [
        SideMenuItem(title: "Home", image: SideMenuIcon.home.image ?? UIImage(), subtitle: []),
        SideMenuItem(title: "Policies", image: SideMenuIcon.policies.image ?? UIImage(), subtitle: ["Find Customer", "Outstanding Task"]),
        SideMenuItem(title: "Products", image: SideMenuIcon.products.image ?? UIImage(), subtitle: ["General Liability", "Commercial Auto", "Inland Marine", "Professional Liability", "Property"]),
        SideMenuItem(title: "Agency Admin", image: SideMenuIcon.agency.image ?? UIImage(), subtitle: ["Reports", "Commissions", "Production Report", "Agency Info", "User Admin"]),
        SideMenuItem(title: "Contact", image: SideMenuIcon.contact.image ?? UIImage(), subtitle: [])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = nil
        tableView.refresh()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(UINib(nibName: "SideMenuHeaderXIB", bundle: nil), forHeaderFooterViewReuseIdentifier: "SideMenuHeaderXIB")
        tableView.register(cellType: SideMenuXIB.self)
    }
    
    @IBAction func generalOnPress(_ sender: UIButton) {
        delegate?.didSelect(menuItem: .general)
    }
    
    @IBAction func professionalOnPress(_ sender: UIButton) {
        delegate?.didSelect(menuItem: .professional)
    }
    
    @IBAction func truckingOnPress(_ sender: UIButton) {
        delegate?.didSelect(menuItem: .trucking)
    }
    
    @IBAction func otherOnPress(_ sender: UIButton) {
        delegate?.didSelect(menuItem: .other)
    }
    
    @objc private func menuOnTap(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 0 || tag == 4 {
            return
        }
        
        let needsReload = selectedIndex == tag
        selectedIndex = needsReload ? nil : tag
        tableView.refresh()
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedIndex == section ? sideMenuItems[section].subtitle.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuHeaderXIB") as? SideMenuHeaderXIB else {
            return nil
        }
        
        let menuItem = sideMenuItems[section]
        view.lblTitle.text = menuItem.title
        view.imgMain.image = menuItem.image
        view.imgDropDown.isHidden = (section == 0 || section == 4)
        view.btnTap.tag = section
        view.btnTap.removeTarget(nil, action: nil, for: .allEvents)
        view.btnTap.addTarget(self, action: #selector(menuOnTap(_:)), for: .touchUpInside)
        
        view.containerView.backgroundColor = section == selectedIndex ? .AppWhiteColor : .clear
        view.imgMain.tintColor = section == selectedIndex ? .LableTittleColor : .AppWhiteColor
        view.lblTitle.textColor = section == selectedIndex ? .LableTittleColor : .AppWhiteColor
        view.imgDropDown.tintColor = section == selectedIndex ? .LableTittleColor : .AppWhiteColor
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuXIB.reuseIdentifier, for: indexPath) as? SideMenuXIB else {
            return UITableViewCell()
        }
        
        let subtitle = sideMenuItems[indexPath.section].subtitle[indexPath.row]
        cell.lblTitle.text = subtitle
        cell.imgMain.isHidden = true
        cell.imgDropDown.isHidden = true
        cell.btnTap.isUserInteractionEnabled = false
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log.error("section : \(indexPath.section) , indexPath : \(indexPath.row)")
        let subtitle = sideMenuItems[indexPath.section].subtitle[indexPath.row]
        SideMenuManager.shared.sideMenuController?.toggleMenu(forceOpen: false)
        switch subtitle{
        case "User Admin" :
            let vc = UsersVC.instantiate(fromStoryboard: .admin,identifier: .UsersVC)
            SideMenuManager.shared.setRootViewController(vc)
        default:
            break
        }
    }
    
}
