//
//  PokemonAbility.swift
//  pokemon_table
//
//  Created by Yana on 17/05/2022.
//

import Foundation
import CoreData

public struct PokemonAbility: Codable, CoreDataStorable {
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case url
    }
    
    public var objectID: NSManagedObjectID?
    public let name: String
    public let effectURL: URL

    public init(from decoder: Decoder) throws {
        let rawResponse = try RawPokemonAbility(from: decoder)
        
        self.name = rawResponse.ability.name
        self.effectURL = rawResponse.ability.url
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(effectURL, forKey: .url)
    }
}

// MARK: -
// MARK: CoreDataInitiable

extension PokemonAbility: CoreDataInitiable {
    
    public typealias CoreDataType = PokemonAbilityModel

    public init(coreDataModel: PokemonAbilityModel) {
        guard let name = coreDataModel.name,
              let url = coreDataModel.effectURL
        else {
            fatalError("Initialization Error")
        }
        
        self.objectID = coreDataModel.objectID
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
