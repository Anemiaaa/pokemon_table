//
//  PokemonFeaturesModel+CoreDataClass.swift
//  
//
//  Created by Yana on 09/06/2022.
//
//

import Foundation
import CoreData


public class PokemonFeaturesModel: NSManagedObject, ManagedObject {

    public typealias ModelType = PokemonFeatures

    public func setFields(model: PokemonFeatures, context: NSManagedObjectContext) {
        self.images = PokemonImagesModel.init(model: model.images, context: context)

        model.abilities.forEach {
            self.addToAbilities(PokemonAbilityModel.init(model: $0, context: context))
        }
    }
}

