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
    
    public func save<T: CoreDataInitiable>(model: T) throws {
        let fetchModel = try self.fetch(model: model)
        
        if fetchModel == nil,
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
    
    public func fetch<T: CoreDataInitiable>(modelType: T.Type) throws -> [T] {
        let coreDataModels: [T.CoreDataType] = try self.fetch(modelType: modelType)
        
        return coreDataModels.compactMap { coreDataModel -> T in
            T.init(coreDataModel: coreDataModel)
        }
    }
    
    public func fetch<T: CoreDataInitiable>(modelType: T.Type) throws -> [T.CoreDataType] {
        let fetchResult = try self.context.fetch(T.CoreDataType.fetchRequest())
        
        if fetchResult.count == 0 {
            return []
        }
        
        return fetchResult.compactMap { coreDataModel -> T.CoreDataType? in
            coreDataModel as? T.CoreDataType
        }
    }
    
    public func fetch<T: CoreDataInitiable>(model: T) throws -> T.CoreDataType?  {
        guard let id = model.objectID else {
            return nil
        }
        return self.context.object(with: id) as? T.CoreDataType
    }
    
    // MARK: -
    // MARK: Private
    
//    private func deleteAllData(_ entity: String) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        fetchRequest.returnsObjectsAsFaults = false
//        do {
//            let results = try context.fetch(fetchRequest)
//            for object in results {
//                guard let objectData = object as? NSManagedObject else {continue}
//                context.delete(objectData)
//            }
//        } catch let error {
//            print("Detele all data in \(entity) error :", error)
//        }
//    }
}
