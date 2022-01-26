//
//  Extensions.swift
//  pokemon_table
//
//  Created by mac on 19.01.2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    static func id() -> String {
        return String(describing: self)
    }
}

extension UITableView {
    
    func register(cell: PokemonCell.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: cell.id())
    }
}

extension UIViewController {
    
    func showAlert(with error: Error) {
        
        let controller = UIAlertController(
            title: "Network Error",
            message: error.localizedDescription,
            preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        controller.addAction(okButton)
        
        self.present(controller, animated: true, completion: nil)
    }
}
