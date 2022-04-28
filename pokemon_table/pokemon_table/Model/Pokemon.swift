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
    public let abilities: [PokemonAbility]
    public let images: PokemonImages
    
    // MARK: -
    // MARK: Initialization
    
    public init(name: String, abilities: [PokemonAbility], images: PokemonImages) {
        self.name = name
        self.abilities = abilities
        self.images = images
    }
}

// MARK: -
// MARK: Codable

extension Pokemon: NetworkProcessable {
    public static var url: URL {
        if let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=") {
            return url
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case url
        case abilities
        case images = "sprites"
    }
}
