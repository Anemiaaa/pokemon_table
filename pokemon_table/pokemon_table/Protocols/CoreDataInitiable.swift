//
//  CoreDataInitial.swift
//  pokemon_table
//
//  Created by Yana on 17/05/2022.
//

import Foundation
import CoreData

public protocol CoreDataInitiable: CoreDataStorable {
    
    associatedtype CoreDataType: ManagedObject
    
    init(coreDataModel: CoreDataType)
}


public protocol CoreDataStorable {
    
    var objectID: NSManagedObjectID? { get set }
}

public protocol ManagedObject: NSManagedObject {
    
    associatedtype ModelType: CoreDataStorable
    
    func setFields(model: ModelType, context: NSManagedObjectContext)
}

extension ManagedObject {
    
    public init(model: ModelType, context: NSManagedObjectContext) {
        self.init(context: context)
        self.setFields(model: model, context: context)
    }
}
