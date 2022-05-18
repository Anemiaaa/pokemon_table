//
//  PokemonModel+CoreDataProperties.swift
//  
//
//  Created by Yana on 18/05/2022.
//
//

import Foundation
import CoreData


extension PokemonModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonModel> {
        return NSFetchRequest<PokemonModel>(entityName: "PokemonModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var url: URL?
    @NSManaged public var features: PokemonFeaturesModel?

}
