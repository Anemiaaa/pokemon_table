//
//  CoreDataWrapper.swift
//  pokemon_table
//
//  Created by Yana on 19/05/2022.
//

import Foundation
import UIKit
import CoreData

public class CoreDataManager: CoreDataManagerProtocol {
    
    // MARK: -
    // MARK: Variables
    
    public let context: NSManagedObjectContext
    
    // MARK: -
    // MARK: Initialization
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: -
    // MARK: Public
    
    public func save<T: CoreDataInitiable>(model: T, request: NSFetchRequest<T.CoreDataType>) throws {
        let fetchModels = try self.fetch(request: request)
        
        if fetchModels.isEmpty,
           let model = model as? T.CoreDataType.ModelType
        {
            let _ = T.CoreDataType.init(
                model: model,
                context: self.context
            )
        }
        
        try self.saveIfNeeded()
    }
    
    public func saveIfNeeded() throws {
        if self.context.hasChanges {
            try self.context.save()
        }
    }
    
    public func fetch<T: CoreDataInitiable>(modelType: T.Type, request: NSFetchRequest<T.CoreDataType>) throws -> [T] {
        let coreDataModels = try self.fetch(request: request)
        
        return coreDataModels.compactMap { coreDataModel -> T in
            T.init(coreDataModel: coreDataModel)
        }
    }
    
    public func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T] {
        return try self.context.fetch(request)
    }
}
