//
//  Extensions.swift
//  pokemon_table
//
//  Created by mac on 19.01.2022.
//

import Foundation
import UIKit

extension UITableView {
    
    func register(for class: AnyClass) {
        let className = String(describing: `class`)
        self.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func dequeueReusableCell<Result>(with cellClass: Result.Type, for indexPath: IndexPath) -> Result
        where Result: UITableViewCell
    {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath)
        
        guard let value = cell as? Result else {
            fatalError("Cannot find id")
        }
        
        return value
    }
}
