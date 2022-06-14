//
//  NetworkDataNodeModel+CoreDataClass.swift
//  
//
//  Created by Yana on 14/06/2022.
//
//

import Foundation
import CoreData


public class NetworkDataNodeModel: NSManagedObject, ManagedObject {

    public typealias ModelType = NetworkDataNode

    public func setFields(model: NetworkDataNode, context: NSManagedObjectContext) {
        self.count = Int64(model.count)
        self.next = model.next
        self.previous = model.previous

        model.results.forEach {
            self.addToResults(PokemonModel.init(model: $0, context: context))
        }
    }
}
