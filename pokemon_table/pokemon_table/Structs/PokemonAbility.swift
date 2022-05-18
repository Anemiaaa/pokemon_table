//
//  PokemonAbility.swift
//  pokemon_table
//
//  Created by Yana on 17/05/2022.
//

import Foundation

public struct PokemonAbility: Codable {
    
    public let name: String
    public let effectURL: URL

    public init(from decoder: Decoder) throws {
        let rawResponse = try RawPokemonAbility(from: decoder)
        
        self.name = rawResponse.ability.name
        self.effectURL = rawResponse.ability.url
    }
}

// MARK: -
// MARK: CoreDataInitiable

extension PokemonAbility: CoreDataInitiable {
    
    public typealias CoreDataType = PokemonAbilityModel
    
    public init(coreDataModel: PokemonAbilityModel) {
        guard let name = coreDataModel.name, let url = coreDataModel.effectURL else {
            fatalError("Initialization Error")
        }
        
        self.name = name
        self.effectURL = url
    }
}

fileprivate struct RawPokemonAbility: Decodable {
    
    struct Ability: Decodable {
        
        let name: String
        let url: URL
    }
    
    let ability: Ability
}
