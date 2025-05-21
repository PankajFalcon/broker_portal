//
//  KeyboardManager.swift
//  Broker Portal
//
//  Created by Pankaj on 14/05/25.
//

import UIKit

public final class KeyboardManager {

    public static let shared = KeyboardManager()
    private var isEnabled = false

    private init() {}

    public func enable() {
        guard !isEnabled else { return }
        isEnabled = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillChange(notification: Notification) {
        adjustKeyboard(with: notification, isHiding: false)
    }

    @objc private func keyboardWillHide(notification: Notification) {
        adjustKeyboard(with: notification, isHiding: true)
    }

    private func adjustKeyboard(with notification: Notification, isHiding: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: \.isKeyWindow),
              let rootVC = window.rootViewController,
              let topVC = Self.findTopViewController(from: rootVC),
              let scrollView = Self.findScrollView(in: topVC.view)
        else { return }

        let bottomInset = isHiding ? 0 : keyboardFrame.height + 20

        UIView.animate(withDuration: 0.25) {
            scrollView.contentInset.bottom = bottomInset
            scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        }
    }

    public static func attachToolbarAndDismissGesture(to view: UIView) {
        applyToolbar(to: view)
        addTapToDismiss(to: view)
    }

    private static func applyToolbar(to view: UIView, toolbar: UIToolbar? = nil) {
        let sharedToolbar = toolbar ?? KeyboardToolbar(view: view)
        for subview in view.subviews {
            switch subview {
            case let tf as UITextField:
                tf.inputAccessoryView = sharedToolbar
            case let tv as UITextView:
                tv.inputAccessoryView = sharedToolbar
            default:
                applyToolbar(to: subview, toolbar: sharedToolbar)
            }
        }
    }

    private static func addTapToDismiss(to view: UIView) {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private static func findScrollView(in view: UIView?) -> UIScrollView? {
        guard let view = view else { return nil }
        if let scroll = view as? UIScrollView { return scroll }
        for sub in view.subviews {
            if let found = findScrollView(in: sub) { return found }
        }
        return nil
    }

    private static func findTopViewController(from root: UIViewController?) -> UIViewController? {
        if let nav = root as? UINavigationController {
            return findTopViewController(from: nav.visibleViewController)
        } else if let tab = root as? UITabBarController {
            return findTopViewController(from: tab.selectedViewController)
        } else if let presented = root?.presentedViewController {
            return findTopViewController(from: presented)
        } else {
            return root
        }
    }
}

private final class KeyboardToolbar: UIToolbar {
    private weak var targetView: UIView?

    init(view: UIView) {
        self.targetView = view
        super.init(frame: .zero)
        sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        items = [.flexibleSpace(), done]
    }

    @objc private func doneTapped() {
        targetView?.endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
