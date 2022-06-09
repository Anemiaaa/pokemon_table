//
//  PokemonManager.swift
//  pokemon_table
//
//  Created by Yana on 16/05/2022.
//

import Foundation
import UIKit
import CoreData

public class PokemonManager: PokemonAPI {

    // MARK: -
    // MARK: Variables

    private let api: PokemonAPI
    private let coreDataManager: CoreDataManagerProtocol
    private let imageCacher: ImageCacher

    // MARK: -
    // MARK: Initialization

    public init(api: PokemonAPI, coreDataManager: CoreDataManagerProtocol, imageCacher: ImageCacher) {
        self.api = api
        self.coreDataManager = coreDataManager
        self.imageCacher = imageCacher
    }

    // MARK: -
    // MARK: Public

    public func pokemons(count: Int, completion: @escaping PokemonCompletion<NetworkDataNode>) -> Task? {
        do {
            let request = NetworkDataNodeModel.fetchRequest()

            let nodes = try self.coreDataManager.fetch(modelType: NetworkDataNode.self, request: request)
            
            if let node = nodes.first {
                completion(.success(node))
                return nil
            }
        
            return self.api.pokemons(count: count) { [weak self] result in
                if let node = try? result.get() {
                    try? self?.coreDataManager.save(model: node, request: request)
                    
                    completion(result)
                }
                
            }
        }
        catch {
            completion(.failure(.anotherError(error)))
            return nil
        }
    }
    
    public func image(features: PokemonFeatures, imageType: PokemonImageTypes, size: CGSize, completion: @escaping PokemonCompletion<UIImage>) -> Task? {
        let request = ImageDataModel.fetchRequest()
        request.predicate = self.handle(imageType: imageType, features: features)
        
        let imageDataModel = try? self.coreDataManager.fetch(request: request).first
        
        if let imageData = imageDataModel?.imageData {
            completion(.success(self.imageCacher.downsample(data: imageData, to: size)))
            return nil
        }
        
        return self.api.image(
            features: features,
            imageType: imageType,
            size: size
        )
        { result in
            let data = (try? result.get())?.pngData()
            
            imageDataModel?.imageData = data
            
            try? self.coreDataManager.saveIfNeeded()
            
            completion(result)
        }
    }
    
    public func features(of pokemon: Pokemon, completion: @escaping PokemonCompletion<PokemonFeatures>) -> Task? {
        let request = PokemonModel.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", pokemon.url as CVarArg)
        
        let pokemonModel = try? self.coreDataManager.fetch(request: request).first
        
        if let features = pokemonModel?.features {
            completion(.success(PokemonFeatures.init(coreDataModel: features)))
            return nil
        }
        
        return self.api.features(of: pokemon) { result in
            do {
                let features = PokemonFeaturesModel.init(model: try result.get(), context: self.coreDataManager.context)
                pokemonModel?.features = features
                
                try self.coreDataManager.saveIfNeeded()
                
                completion(result)
            }
            catch {
                completion(.failure(.anotherError(error)))
            }
        }
    }
    
    public func effect(of ability: PokemonAbility, completion: @escaping PokemonCompletion<EffectEntry>) -> Task? {
        let request = PokemonAbilityModel.fetchRequest()
        request.predicate =  NSPredicate(format: "effectURL == %@", ability.effectURL as CVarArg)
        
        if let abilityModel = try? self.coreDataManager.fetch(request: request).first {
            if let entry = abilityModel.effectEntry {
                completion(.success(EffectEntry(entry: entry)))
                return nil
            }
            return self.api.effect(of: ability) { result in
                do {
                    let entry = try result.get()
                    abilityModel.effectEntry = entry.entry
                    
                    try self.coreDataManager.saveIfNeeded()
                    
                    completion(result)
                }
                catch {
                    completion(.failure(.anotherError(error)))
                }
            }
        }
        return nil
    }
    
    // MARK: -
    // MARK: Private
    
    private func handle(imageType: PokemonImageTypes, features: PokemonFeatures) -> NSPredicate? {
        switch imageType {
        case .backDefault:
            return NSPredicate(format: "url == %@", features.images.backDefault as CVarArg)
        case .backFemale:
            guard let backFemale = features.images.backFemale else {
                return nil
            }
             return NSPredicate(format: "url == %@", backFemale as CVarArg)
        case .backShiny:
            return NSPredicate(format: "url == %@", features.images.backShiny as CVarArg)
        case .backShinyFemale:
            guard let backShinyFemale = features.images.frontShinyFemale else {
                return nil
            }
            return NSPredicate(format: "url == %@", backShinyFemale as CVarArg)
        case .frontDefault:
            return NSPredicate(format: "url == %@", features.images.frontDefault as CVarArg)
        case .frontFemale:
            guard let frontFemale = features.images.frontFemale else {
                return nil
            }
            return NSPredicate(format: "url == %@", frontFemale as CVarArg)
        case .frontShiny:
            return NSPredicate(format: "url == %@", features.images.frontShiny as CVarArg)
        case .frontShinyFemale:
            guard let frontShinyFemale = features.images.frontShinyFemale else {
                return nil
            }
            return NSPredicate(format: "url == %@", frontShinyFemale as CVarArg)
        }
    }
}
