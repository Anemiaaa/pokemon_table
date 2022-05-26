//
//  PokemonImagesModel+CoreDataClass.swift
//  
//
//  Created by Yana on 26/05/2022.
//
//

import Foundation
import CoreData


public class PokemonImagesModel: NSManagedObject, ManagedObject {

    public typealias ModelType = PokemonImages
    
    public func setFields(model: PokemonImages, context: NSManagedObjectContext) {
        self.backDefault = model.backDefault
        self.backFemale = model.backFemale
        self.backShiny = model.backShiny
        self.backShinyFemale = model.backShinyFemale
        self.frontDefault = model.frontDefault
        self.frontFemale = model.frontFemale
        self.frontShiny = model.frontShiny
        self.frontShinyFemale = model.frontShinyFemale
    }
}
