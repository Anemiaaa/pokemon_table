//
//  PokemonAbilityModel+CoreDataClass.swift
//  
//
//  Created by Yana on 09/06/2022.
//
//

import Foundation
import CoreData


public class PokemonAbilityModel: NSManagedObject, ManagedObject {

    public typealias ModelType = PokemonAbility

    public func setFields(model: PokemonAbility, context: NSManagedObjectContext) {
        self.name = model.name
        self.effectURL = model.effectURL
    }
}
