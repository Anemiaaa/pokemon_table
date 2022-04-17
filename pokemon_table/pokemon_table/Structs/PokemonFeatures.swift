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

public struct PokemonAbility: NetworkProcessable {
    
    public let name: String
    public let url: URL

    public init(from decoder: Decoder) throws {
        let rawResponse = try RawPokemonAbility(from: decoder)
        
        self.name = rawResponse.ability.name
        self.url = rawResponse.ability.url
    }
}

public struct EffectEntry: NetworkProcessable {
    
    public let entry: String?
    
    public init(from decoder: Decoder) throws {
        let rawResponse = try RawEffect(from: decoder)
        
        let effect = rawResponse.effects
            .first(where: { $0.language.name == "en" })
        
        self.entry = effect?.entry
    }
}

extension PokemonFeatures: NetworkProcessable {
    
    enum CodingKeys: String, CodingKey {
        
        case abilities
        case images = "sprites"
    }
}

fileprivate struct RawPokemonAbility: Decodable {
    
    struct Ability: Decodable {
        
        let name: String
        let url: URL
    }
    
    let ability: Ability
}

fileprivate struct RawEffect: Decodable {
    
    let effects: [Effect]
    
    enum CodingKeys: String, CodingKey {
        
        case effects = "effect_entries"
    }
    
    struct Language: Decodable {
        
        let name: String
    }
    
    struct Effect: Decodable {
        
        let entry: String
        let language: Language
        
        enum CodingKeys: String, CodingKey {
            
            case entry = "effect"
            case language
        }
    }
}
