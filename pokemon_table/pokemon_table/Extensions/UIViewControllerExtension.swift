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
        
        self.showAlert(title: title, message: error.localizedDescription)
    }
    
    func showAlert(title: String, message: String?) {
        DispatchQueue.main.sync {
            let controller = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            controller.addAction(okButton)
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func add(_ child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        
        child.didMove(toParent: self)
    }

    func remove() {
        guard self.parent != nil else {
            return
        }

        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        
        self.removeFromParent()
    }
}
