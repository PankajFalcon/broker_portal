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
    private var timeoutTask: Task<Void, Never>? // Task to delay loader display
    private var isLoaderVisible = false
    
    init() {}
    
    // Starts a delay, shows loader only if API call exceeds 2 seconds
    func showLoadingWithDelay() {
        // Cancel previous task if any
        timeoutTask?.cancel()
        
        // Start a new delay task
        timeoutTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // Wait 2 seconds
                await self?.showLoader() // Only show loader if still waiting
            } catch {
                // Ignore cancellation error
            }
        }
    }
    
    // Immediately shows the loader
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
    
    // Cancels the delay and hides the loader
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
