//
//  NetworkDataNode.swift
//  pokemon_table
//
//  Created by mac on 13.01.2022.
//

import Foundation

public struct NetworkDataNode: NetworkProcessable
{    
    var count: Int
    var next: URL?
    var previous: URL?
    var results: [Pokemon]
}

// MARK: -
// MARK: CoreDataInitiable

extension NetworkDataNode: CoreDataInitiable {
    
    public typealias CoreDataType = NetworkDataNodeModel
    
    public init(coreDataModel: NetworkDataNodeModel) {
        guard let results: [Pokemon] = coreDataModel.results?.compactMap ({ model -> Pokemon? in
            if let model = model as? Pokemon.CoreDataType {
                return Pokemon.init(coreDataModel: model)
            }
            return nil
        }) else {
            fatalError("Initialization problem")
        }

        
        self.count = Int(truncatingIfNeeded: coreDataModel.count)
        self.next = coreDataModel.next
        self.previous = coreDataModel.previous
        self.results = results
    }
}
