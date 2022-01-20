//
//  PokemonNetworkAPI.swift
//  pokemon_table
//
//  Created by mac on 17.01.2022.
//

import Foundation
import UIKit

public enum PokemonApiError: Error {
    
    case incorrectInputFormat
    case urlInit
    case networkError(Error)
    case imageNotExist
    case instanceDeath
}

public class PokemonNetworkAPI: PokemonAPI {

    // MARK: -
    // MARK: Type Inferences
    
    public enum Links {
        static let random = "https://pokeapi.co/api/v2/pokemon?limit="
    }
    
    // MARK: -
    // MARK: Initialization
    
    public init() {}
    
    // MARK: -
    // MARK: Public
    
    public func pokemons(count: Int, completion: @escaping F.PokemonCompletion<NetworkDataNode<[Pokemon]>>) {
        guard count > 0 else {
            completion(.failure(.incorrectInputFormat))
            return
        }
        guard let url = URL(string: Links.random + String(count)) else {
            completion(.failure(.urlInit))
            return
        }

        NetworkHelper.data(dataType: NetworkDataNode<[Pokemon]>.self, url: url) { [weak self] result in
            completion(self?.lift(response: result) ?? .failure(.instanceDeath))
        }
    }
    
    public func features(pokemon: Pokemon, completion: @escaping F.PokemonCompletion<PokemonFeatures>) {
        NetworkHelper.data(dataType: PokemonFeatures.self, url: pokemon.url) { [weak self] result in
            completion(self?.lift(response: result) ?? .failure(.instanceDeath))
        }
    }
    
    public func effect(of ability: PokemonAbility, completion: @escaping F.PokemonCompletion<AbilityEffects>) {
        guard let urlString = ability.ability["url"], let url = URL(string: urlString) else {
            completion(.failure(.urlInit))
            return
        }
        
        NetworkHelper.data(dataType: AbilityEffects.self, url: url) { [weak self] result in
            completion(self?.lift(response: result) ?? .failure(.instanceDeath))
        }
    }
    
    public func images(pokemon: Pokemon, imageType: PokemonImageTypes, completion: @escaping F.PokemonCompletion<Data>) {
        self.features(pokemon: pokemon) { [weak self] result in
            switch result {
                
            case .success(let pokemonFeatures):
                guard let url = self?.url(from: pokemonFeatures, to: imageType) else {
                    completion(.failure(.imageNotExist))
                    return
                }

                NetworkHelper.image(url: url) { [weak self] result in
                    completion(self?.lift(response: result) ?? .failure(.instanceDeath))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -
    // MARK: Private

    private func lift<T>(response: NetworkResult<T>) -> F.PokemonResult<T> {
        switch response {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(.networkError(error))
        }
    }
    
    private func url(from features: PokemonFeatures, to type: PokemonImageTypes) -> URL? {
        let images = features.images
        
        switch type {
        case .backDefault:
            return images.backDefault
        case .backFemale:
            return images.backFemale
        case .backShiny:
            return images.backShiny
        case .backShinyFemale:
            return images.backShinyFemale
        case .frontDefault:
            return images.frontDefault
        case .frontFemale:
            return images.frontFemale
        case .frontShiny:
            return images.frontShiny
        case .frontShinyFemale:
            return images.frontShinyFemale
        }
    }
}
