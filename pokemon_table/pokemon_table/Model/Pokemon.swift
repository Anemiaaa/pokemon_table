//
//  Pokemon.swift
//  pokemon_table
//
//  Created by mac on 17.01.2022.


import Foundation

public struct Pokemon: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case url
    }

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
// MARK: CoreDataInitiable

extension Pokemon: CoreDataInitiable {

    public typealias CoreDataType = PokemonModel
    
    public init(coreDataModel: PokemonModel) {
        guard let name = coreDataModel.name, let url = coreDataModel.url else {
            fatalError("Initialization error")
        }
        
        self.name = name
        self.url = url
    }
    
}
