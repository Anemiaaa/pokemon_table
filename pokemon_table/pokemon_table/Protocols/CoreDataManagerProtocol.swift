//
//  CoreDataManager.swift
//  pokemon_table
//
//  Created by Yana on 19/05/2022.
//

import Foundation
import CoreData

public protocol CoreDataManagerProtocol {
    
    var context: NSManagedObjectContext { get }
    
    func saveIfNeeded() throws
    
    func save<T: CoreDataInitiable>(model: T, request: NSFetchRequest<T.CoreDataType>) throws
    
    func fetch<T: CoreDataInitiable>(modelType: T.Type, request: NSFetchRequest<T.CoreDataType>) throws -> [T]
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T]
}
