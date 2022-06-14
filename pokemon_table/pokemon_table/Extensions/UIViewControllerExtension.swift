//
//  UIViewControllerExtension.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit

extension UIViewController {

    func showAlert(title: String, error: Error) {
        if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
            self.showAlert(title: "No Internet connection!", message: nil)
            return 
        }
        self.showAlert(title: title, message: error.localizedDescription)
    }
    
    func showAlert(title: String, message: String?) {
        DispatchQueue.main.async {
            let controller = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            controller.addAction(okButton)
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func switchResult<T, Error>(result: Result<T, Error>, unwrappedValue: (T) -> ()) {
        switch result {
        case .success(let value):
            unwrappedValue(value)
        case .failure(let error):
            self.showAlert(title: "Error", error: error)
        }
    }
}
