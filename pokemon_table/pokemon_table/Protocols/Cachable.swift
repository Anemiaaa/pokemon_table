//
//  Cachable.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit

public protocol Cachable {

    associatedtype Key: Any
    associatedtype Value: Any
    
    func insert(value: Value, for key: Key)
    
    func remove(for key: Key)
    
    func cachedData(for key: Key) -> Value?
}
