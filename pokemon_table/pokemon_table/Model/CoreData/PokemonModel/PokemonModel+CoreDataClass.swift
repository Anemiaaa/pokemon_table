//
//  PokemonModel+CoreDataClass.swift
//  
//
//  Created by Yana on 26/05/2022.
//
//

import Foundation
import CoreData


public class PokemonModel: NSManagedObject, ManagedObject {
    
    public typealias ModelType = Pokemon
    
    public func setFields(model: Pokemon, context: NSManagedObjectContext) {
        self.id = model.id
        self.name = model.name
        self.url = model.url
    }
}
