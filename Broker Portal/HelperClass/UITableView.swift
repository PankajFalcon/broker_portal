//
//  UITableView.swift
//  Broker Portal
//
//  Created by Pankaj on 28/04/25.
//

import UIKit

extension UITableView {
    
    /// Adds a pull-to-refresh control to the table view
    func addRefreshControl(action: @escaping () -> Void) {
        let refreshControl = UIRefreshControl()
        refreshControl.addAction(for: .valueChanged, action)
        self.refreshControl = refreshControl
    }
    
    /// Ends refreshing animation if refreshing
    func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            if self?.refreshControl?.isRefreshing == true {
                self?.refreshControl?.endRefreshing()
            }
        }
    }
    
    /// Reloads table view data on the main thread safely
    func refresh() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
    
    /// Registers a UITableViewCell using its class name automatically
    func register(cellType: UITableViewCell.Type) {
        let className = String(describing: cellType)
        self.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    /// Dequeues a reusable UITableViewCell in a type-safe way
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let className = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else {
            fatalError("Error: Could not dequeue cell with identifier: \(className)")
        }
        return cell
    }
}


// MARK: - UIControl Helper
private extension UIControl {
    
    /// Adds an action closure to UIControl (for UIRefreshControl)
    func addAction(for event: UIControl.Event, _ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: event)
        objc_setAssociatedObject(self, UUID().uuidString, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

/// Helper class to wrap closures for UIControl
private class ClosureSleeve {
    let closure: () -> Void
    
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    @objc func invoke() {
        closure()
    }
}
