//
//  PokemonAbilityModel+CoreDataProperties.swift
//  
//
//  Created by Yana on 09/06/2022.
//
//

import Foundation
import CoreData


extension PokemonAbilityModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonAbilityModel> {
        return NSFetchRequest<PokemonAbilityModel>(entityName: "PokemonAbilityModel")
    }

    @NSManaged public var effectEntry: String?
    @NSManaged public var effectURL: URL?
    @NSManaged public var name: String?
    @NSManaged public var parent: PokemonFeaturesModel?

}
