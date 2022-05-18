//
//  PokemonAbilityModel+CoreDataProperties.swift
//  
//
//  Created by Yana on 18/05/2022.
//
//

import Foundation
import CoreData


extension PokemonAbilityModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonAbilityModel> {
        return NSFetchRequest<PokemonAbilityModel>(entityName: "PokemonAbilityModel")
    }

    @NSManaged public var effectURL: URL?
    @NSManaged public var name: String?

}
