//
//  BaseCell.swift
//  pokemon_table
//
//  Created by mac on 15.02.2022.
//

import Foundation
import UIKit

public class BaseCell<Model, Events>: UITableViewCell, AnyCellType {
    
    public var eventHandler: F.Handler<Events>?
    
    // MARK: -
    // MARK: Cell Life Cycle

    open override func prepareForReuse() {
        self.eventHandler = nil
        super.prepareForReuse()
    }
    
    //MARK: -
    //MARK: AnyCellType
    
    public func fill(with model: Any, eventHandler: @escaping F.Handler<Any>) {
        self.eventHandler = {
            eventHandler($0)
        }
        if let value = model as? Model {
            self.fill(with: value)
        }
    }
    
    open func fill(with model: Model) {
        fatalError("Doesnt override fill(with:) function")
    }
}
