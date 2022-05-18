//
//  CoreDataInitial.swift
//  pokemon_table
//
//  Created by Yana on 17/05/2022.
//

import Foundation
import CoreData

public protocol CoreDataInitiable: ErasedCoreDataTypeInitiable {
    
    associatedtype CoreDataType: NSManagedObject
    
    init(coreDataModel: CoreDataType)
}

public protocol ErasedCoreDataTypeInitiable {
    
    var erasedCoreDataType: NSManagedObject.Type { get }
}

public extension ErasedCoreDataTypeInitiable where Self: CoreDataInitiable {
    
    var erasedCoreDataType: NSManagedObject.Type { return CoreDataType.self }
}

public protocol ManagedObject: NSManagedObject {

}

