//
//  PokemonImagesModel+CoreDataProperties.swift
//  
//
//  Created by Yana on 18/05/2022.
//
//

import Foundation
import CoreData


extension PokemonImagesModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonImagesModel> {
        return NSFetchRequest<PokemonImagesModel>(entityName: "PokemonImagesModel")
    }

    @NSManaged public var backDefault: URL?
    @NSManaged public var backFemale: URL?
    @NSManaged public var backShiny: URL?
    @NSManaged public var backShinyFemale: URL?
    @NSManaged public var frontDefault: URL?
    @NSManaged public var frontFemale: URL?
    @NSManaged public var frontShiny: URL?
    @NSManaged public var frontShinyFemale: URL?

}
