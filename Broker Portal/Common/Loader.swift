//
//  Loader.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

import UIKit

class LoaderManager {
    
    private weak var loaderView: UIView?
    private weak var activityIndicator: UIActivityIndicatorView?
    private var timeoutTask: Task<Void, Never>?
    private var isLoaderVisible = false
    
    init() {}
    
    func showLoadingWithDelay() {
        // Cancel previous task if any
        timeoutTask?.cancel()
        
        timeoutTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 0 * 1_000_000_000) // Wait 2 seconds
                
                // Check if task is cancelled after sleeping
                try Task.checkCancellation()
                
                await self?.showLoader()
                
            } catch {
                // Task was cancelled, no loader will be shown
            }
        }
    }
    
    @MainActor
    private func showLoader() {
        guard !isLoaderVisible else { return }
        isLoaderVisible = true
        
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let loaderBackgroundView = UIView(frame: window.bounds)
        loaderBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loaderBackgroundView.center
        activityIndicator.startAnimating()
        
        loaderBackgroundView.addSubview(activityIndicator)
        window.addSubview(loaderBackgroundView)
        
        self.loaderView = loaderBackgroundView
        self.activityIndicator = activityIndicator
    }
    
    func hideLoading() {
        timeoutTask?.cancel()
        timeoutTask = nil
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loaderView?.removeFromSuperview()
            self.activityIndicator?.stopAnimating()
            self.loaderView = nil
            self.activityIndicator = nil
            self.isLoaderVisible = false
        }
    }
}
