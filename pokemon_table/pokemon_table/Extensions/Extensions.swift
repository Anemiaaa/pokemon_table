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
    
    func register(cell: UITableViewCell.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: cell.id())
    }
}

extension URL {
    
    var fileSize: UInt64? {
        get {
        let attributes = try? FileManager.default.attributesOfItem(atPath: path)
            
        return attributes?[.size] as? UInt64
        }
    }
         
}

