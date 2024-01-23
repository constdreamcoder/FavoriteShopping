//
//  UIViewController+Extension.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 1/18/24.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        String(describing: self)
    }
    
    func createAnAlert(title: String, message: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirmButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
}
