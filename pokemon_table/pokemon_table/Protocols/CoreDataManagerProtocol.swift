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
    
    func save<T: CoreDataInitiable>(model: T) throws
    
    func saveIfNeeded() throws
    
    func fetch<T: CoreDataInitiable>(modelType: T.Type) throws -> [T]
    
    func fetch<T: CoreDataInitiable>(modelType: T.Type) throws -> [T.CoreDataType]
    
    func fetch<T: CoreDataInitiable>(model: T) throws -> T.CoreDataType?
}
