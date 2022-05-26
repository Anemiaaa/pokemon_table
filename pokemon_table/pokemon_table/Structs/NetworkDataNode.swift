//
//  NetworkDataNode.swift
//  pokemon_table
//
//  Created by mac on 13.01.2022.
//

import Foundation
import CoreData

public struct NetworkDataNode: CoreDataStorable
{
    public var objectID: NSManagedObjectID?
    public var count: Int
    public var next: URL?
    public var previous: URL?
    public var results: [Pokemon]
}

// MARK: -
// MARK: NetworkProcessable

extension NetworkDataNode: NetworkProcessable {
    
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
        guard let results: [Pokemon] = coreDataModel.results?.compactMap ({ model -> Pokemon? in
            if let model = model as? Pokemon.CoreDataType {
                return Pokemon.init(coreDataModel: model)
            }
            return nil
        }) else {
            fatalError("Initialization problem")
        }

        self.objectID = coreDataModel.objectID
        self.count = Int(truncatingIfNeeded: coreDataModel.count)
        self.next = coreDataModel.next
        self.previous = coreDataModel.previous
        self.results = results
    }
}
