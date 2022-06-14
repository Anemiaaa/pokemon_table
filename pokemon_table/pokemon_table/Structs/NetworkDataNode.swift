//
//  NetworkDataNode.swift
//  pokemon_table
//
//  Created by mac on 13.01.2022.
//

import Foundation
import CoreData

public struct NetworkDataNode: NetworkProcessable
{
    public var count: Int
    public var next: URL?
    public var previous: URL?
    public var results: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        
        case count
        case next
        case previous
        case results
    }
}

// MARK: -
// MARK: CoreDataInitiable

extension NetworkDataNode: CoreDataInitiable {
    
    public typealias CoreDataType = NetworkDataNodeModel
    
    public init(coreDataModel: NetworkDataNodeModel) {
        guard let results: [Pokemon] = coreDataModel.results?
            .compactMap({ pokemon -> PokemonModel? in pokemon as? PokemonModel})
            .sorted(by: { $0.numberInOrder < $1.numberInOrder})
            .compactMap ({ model -> Pokemon? in
                    Pokemon.init(coreDataModel: model)
        }) else {
            fatalError("Initialization problem")
        }

        self.count = Int(truncatingIfNeeded: coreDataModel.count)
        self.next = coreDataModel.next
        self.previous = coreDataModel.previous
        self.results = results
    }
}
