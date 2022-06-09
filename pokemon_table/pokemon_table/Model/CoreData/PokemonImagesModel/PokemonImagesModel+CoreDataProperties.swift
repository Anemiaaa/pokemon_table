//
//  PokemonImagesModel+CoreDataProperties.swift
//  
//
//  Created by Yana on 09/06/2022.
//
//

import Foundation
import CoreData


extension PokemonImagesModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonImagesModel> {
        return NSFetchRequest<PokemonImagesModel>(entityName: "PokemonImagesModel")
    }

    @NSManaged public var backDefault: ImageDataModel?
    @NSManaged public var backFemale: ImageDataModel?
    @NSManaged public var backShiny: ImageDataModel?
    @NSManaged public var backShinyFemale: ImageDataModel?
    @NSManaged public var frontDefault: ImageDataModel?
    @NSManaged public var frontFemale: ImageDataModel?
    @NSManaged public var frontShiny: ImageDataModel?
    @NSManaged public var frontShinyFemale: ImageDataModel?
    @NSManaged public var parent: PokemonFeaturesModel?

}
