//
//  BaseViewController+Alerts.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import UIKit

extension BaseViewController {
    
    func showAlert(error: Error?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error",
                                          message: error?.localizedDescription ?? "Unknown error",
                                          preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
