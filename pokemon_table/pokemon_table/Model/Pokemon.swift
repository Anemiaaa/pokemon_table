//
//  Pokemon.swift
//  pokemon_table
//
//  Created by mac on 17.01.2022.
//

import Foundation

public struct Pokemon {

    // MARK: -
    // MARK: Variables
    
    public let id = UUID()
    public let name: String
    public let url: URL
    
    // MARK: -
    // MARK: Initialization
    
    public init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}

// MARK: -
// MARK: Codable

extension Pokemon: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case url
    }
}
