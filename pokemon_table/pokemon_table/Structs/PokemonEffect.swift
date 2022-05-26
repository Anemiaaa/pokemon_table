//
//  PokemonEffect.swift
//  pokemon_table
//
//  Created by Yana on 17/05/2022.
//

import Foundation

public struct EffectEntry: NetworkProcessable, Codable {
    
    public let entry: String?
    
    public init(entry: String?) {
        self.entry = entry
    }
    
    public init(from decoder: Decoder) throws {
        let rawResponse = try RawEffect(from: decoder)
        
        let effect = rawResponse.effects
            .first(where: { $0.language.name == "en" })
        
        self.entry = effect?.entry
    }
}

// MARK: -
// MARK: CoreDataInitiable

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
