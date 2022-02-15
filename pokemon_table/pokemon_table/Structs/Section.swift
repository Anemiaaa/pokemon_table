//
//  Section.swift
//  pokemon_table
//
//  Created by mac on 15.02.2022.
//

import Foundation
import UIKit

public struct Section {
    
    // MARK: -
    // MARK: Variables
    
    public var models: [Any]
    
    public let cell: AnyCellType.Type

    // MARK: -
    // MARK: Initialization
    
    public init<Cell, Model, Events>(cell: Cell.Type, models: [Model]) where Cell: BaseCell<Model, Events> {
        self.cell = cell
        self.models = models
    }
}
