//
//  AnyCellType.swift
//  pokemon_table
//
//  Created by mac on 15.02.2022.
//

import Foundation
import UIKit

public protocol AnyCellType: UITableViewCell {
    
    func fill(with model: Any, eventHandler: @escaping F.Handler<Any>)
}
