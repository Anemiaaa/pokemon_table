//
//  PokemonImagesModel+CoreDataClass.swift
//  
//
//  Created by Yana on 09/06/2022.
//
//

import Foundation
import CoreData


public class PokemonImagesModel: NSManagedObject, ManagedObject {

    public typealias ModelType = PokemonImages

    public func setFields(model: PokemonImages, context: NSManagedObjectContext) {
        self.backDefault = ImageDataModel(context: context, url: model.backDefault, imageData: nil)
        self.backFemale = ImageDataModel(context: context, url: model.backFemale, imageData: nil)
        self.backShiny = ImageDataModel(context: context, url: model.backShiny, imageData: nil)
        self.backShinyFemale = ImageDataModel(context: context, url: model.backShinyFemale, imageData: nil)
        self.frontDefault = ImageDataModel(context: context, url: model.frontDefault, imageData: nil)
        self.frontFemale = ImageDataModel(context: context, url: model.frontFemale, imageData: nil)
        self.frontShiny = ImageDataModel(context: context, url: model.frontShiny, imageData: nil)
        self.frontShinyFemale = ImageDataModel(context: context, url: model.frontShinyFemale, imageData: nil)
    }
}
