//
//  PokemonAbility.swift
//  pokemon_table
//
//  Created by mac on 17.01.2022.
//

import Foundation

public struct PokemonFeatures {
    
    public let abilities: [PokemonAbility]
    public let images: PokemonImages
}

public struct PokemonAbility: Codable {
    
    public let ability: [String: String]
}

public struct AbilityEffects {
    
    public let entry: EffectEntry
}

public struct EffectEntry: Codable {
    
    public let effect: String
    public let language: [String: String]
}

extension PokemonFeatures: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case abilities
        case images = "sprites"
    }
}

extension AbilityEffects: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case entry = "effect_entries"
    }
}
