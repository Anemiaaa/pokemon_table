//
//  Extensions.swift
//  pokemon_table
//
//  Created by Yana on 21/04/2022.
//

import Foundation

extension Int: QueryParamsType {
    
}

extension URL {
    
    public func append(_ string: String) -> URL? {
        URL(string: self.absoluteString + string)
    }
    
    public func append(_ int: Int) -> URL? {
        self.append(String(int))
    }
}
