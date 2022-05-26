//
//  PokemonFeaturesModel+CoreDataProperties.swift
//  
//
//  Created by Yana on 26/05/2022.
//
//

import Foundation
import CoreData


extension PokemonFeaturesModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonFeaturesModel> {
        return NSFetchRequest<PokemonFeaturesModel>(entityName: "PokemonFeaturesModel")
    }

    @NSManaged public var abilities: NSSet?
    @NSManaged public var images: PokemonImagesModel?

}

// MARK: Generated accessors for abilities
extension PokemonFeaturesModel {

    @objc(addAbilitiesObject:)
    @NSManaged public func addToAbilities(_ value: PokemonAbilityModel)

    @objc(removeAbilitiesObject:)
    @NSManaged public func removeFromAbilities(_ value: PokemonAbilityModel)

    @objc(addAbilities:)
    @NSManaged public func addToAbilities(_ values: NSSet)

    @objc(removeAbilities:)
    @NSManaged public func removeFromAbilities(_ values: NSSet)

}
