//
//  PokemonAbility.swift
//  pokemon_table
//
//  Created by mac on 17.01.2022.
//

import Foundation
import CoreData
import UIKit

public struct PokemonFeatures: Codable, CoreDataStorable {
    
    public var objectID: NSManagedObjectID?
    public let abilities: [PokemonAbility]
    public let images: PokemonImages
}

extension PokemonFeatures: NetworkProcessable {
    
    enum CodingKeys: String, CodingKey {
        
        case abilities
        case images = "sprites"
    }
}

extension PokemonFeatures: CoreDataInitiable {
    
    public typealias CoreDataType = PokemonFeaturesModel
    
    public init(coreDataModel: PokemonFeaturesModel) {
        self.objectID = coreDataModel.objectID
        
        guard let abilities = coreDataModel.abilities, let images = coreDataModel.images else {
            fatalError("Initialization Error")
        }

        self.abilities = abilities.compactMap { model -> PokemonAbility? in
            if let model = model as? PokemonAbility.CoreDataType {
                return PokemonAbility.init(coreDataModel: model)
            }
            return nil
        }
        
        self.images = PokemonImages.init(coreDataModel: images)
    }
}
