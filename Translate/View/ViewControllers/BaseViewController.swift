//
//  BaseViewController.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: Properties
    private(set) var keyboardHeight: CGFloat = 0
    lazy var router: IRouter = Router.shared

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSubviews()

        let closeKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboardTapAction))
        closeKeyboardTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(closeKeyboardTap)
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

// MARK: - Notifications
extension BaseViewController {
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        self.keyboardHeight = keyboardFrame.cgRectValue.height
        
        self.willUpdateKeyboardHeight()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.keyboardHeight = 0
        
        self.willUpdateKeyboardHeight()
    }
    
    @objc public func willUpdateKeyboardHeight() {
        
    }
}

// MARK: - Actions
extension BaseViewController {
    
    @objc private func closeKeyboardTapAction() {
        self.view.endEditing(true)
    }
}

// MARK: - Subviews
extension BaseViewController {
    
    @objc public func addSubviews() {

    }
    
    func realFrame() -> CGRect {
        let y = self.view.safeAreaInsets.top
        let x = self.view.safeAreaInsets.left
        let width = self.view.frame.size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right
        let height = self.view.frame.size.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
