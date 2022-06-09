//
//  Pokemon.swift
//  pokemon_table
//
//  Created by mac on 17.01.2022.


import Foundation
import CoreData

public struct Pokemon: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case url
    }

    // MARK: -
    // MARK: Variables
    
    public let id: UUID
    public let name: String
    public let url: URL
    
    // MARK: -
    // MARK: Initialization
    
    public init(name: String, url: URL) {
        self.id = UUID()
        self.name = name
        self.url = url
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        self.url = try values.decode(URL.self, forKey: .url)
        self.name = try values.decode(String.self, forKey: .name)
    }
}

// MARK: -
// MARK: Codable

extension Pokemon: NetworkProcessable {
    
    public typealias ReturnedType = NetworkDataNode
    
    public static var url: URL? {
        if let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=") {
            return url
        }
        return nil
    }
}

// MARK: -
// MARK: CoreDataStorable

extension Pokemon: CoreDataInitiable {

    public typealias CoreDataType = PokemonModel
    
    public init(coreDataModel: PokemonModel) {
        guard let name = coreDataModel.name,
              let url = coreDataModel.url,
              let id = coreDataModel.id
        else {
            fatalError("Initialization error")
        }
        
        self.id = id
        self.name = name
        self.url = url
    }
    
}
