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

    // MARK: -
    // MARK: Initialization

    public init(api: PokemonAPI, coreDataManager: CoreDataManagerProtocol) {
        self.api = api
        self.coreDataManager = coreDataManager
    }

    // MARK: -
    // MARK: Public

    public func pokemons(count: Int, completion: @escaping PokemonCompletion<NetworkDataNode>) -> Task? {
        do {
            let models: [NetworkDataNode] = try self.coreDataManager.fetch(modelType: NetworkDataNode.self)
            
            if let node = models.first {
                completion(.success(node))
                return nil
            }
        
            return self.api.pokemons(count: count) { [weak self] result in
                self?.save(result: result, completion: {
                    completion($0)
                })
            }
        }
        catch {
            completion(.failure(.anotherError(error)))
            return nil
        }
    }
    
    public func image(features: PokemonFeatures, imageType: PokemonImageTypes, size: CGSize, completion: @escaping PokemonCompletion<UIImage>) -> Task? {
        self.api.image(
            features: features,
            imageType: imageType,
            size: size
        ) {
            completion($0)
        }
    }
    
    public func features(of pokemon: Pokemon, completion: @escaping PokemonCompletion<PokemonFeatures>) -> Task? {
        do {
            let pokemonModel = try self.coreDataManager.fetch(model: pokemon)
            
            if let features = pokemonModel?.features {
                completion(.success(PokemonFeatures.init(coreDataModel: features)))
                return nil
            }
            
            return self.api.features(of: pokemon) { result in
                do {
                    let feature = try result.get()
                    pokemonModel?.features = PokemonFeaturesModel.init(model: feature, context: self.coreDataManager.context)
                    
                    try self.coreDataManager.saveIfNeeded()
                    
                    completion(result)
                }
                catch {
                    completion(.failure(.anotherError(error)))
                }
            }
        }
        catch {
            completion(.failure(.anotherError(error)))
        }
        return nil
    }
    
    public func effect(of ability: PokemonAbility, completion: @escaping PokemonCompletion<EffectEntry>) -> Task? {
        do {
            if let abilityModel = try self.coreDataManager.fetch(model: ability) {
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
        }
        catch {
            completion(.failure(.anotherError(error)))
        }
        return nil
    }
    
    // MARK: -
    // MARK: Private
    
    private func save<T: CoreDataInitiable>(result: PokemonResult<T>, completion: PokemonCompletion<T>) {
        do {
            let model = try result.get()
            
            try? self.coreDataManager.save(model: model)
            
            completion(.success(model))
        }
        catch {
            completion(.failure(.anotherError(error)))
        }
    }
}
