//
//  PokemonNetworkAPI.swift
//  pokemon_table
//
//  Created by mac on 17.01.2022.
//

import Foundation
import UIKit
import RxSwift

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
    
    private enum Links {
        
        static let random = "https://pokeapi.co/api/v2/pokemon?limit="
    }

    // MARK: -
    // MARK: Variables
    
    private var imageCashe: [URL: Data] = [:]
    
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

        self.networkData(from: NetworkDataNode<[Pokemon]>.self, url: url) {
            completion($0)
        }
    }
    
    public func features(pokemon: Pokemon, completion: @escaping F.PokemonCompletion<PokemonFeatures>) {
        self.networkData(from: PokemonFeatures.self, url: pokemon.url) {
            completion($0)
        }
    }
    
    public func effect(of ability: PokemonAbility, completion: @escaping F.PokemonCompletion<EffectEntry>) {
        self.networkData(from: EffectEntry.self, url: ability.url) {
            completion($0)
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
                if let image = self?.imageCashe[url] {
                    completion(.success(image))
                    return
                }

                NetworkHelper.image(url: url) { [weak self] result in
                    switch result {
                    case .success(let image):
                        self?.imageCashe[url] = image
                        
                        completion(.success(image))
                    case .failure(let error):
                        completion(.failure(.networkError(error)))
                    }
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
    
    private func networkData<T: Codable>(
        from decodeDataType: T.Type,
        url: URL,
        completion: @escaping F.PokemonCompletion<T>)
    {
        NetworkHelper.data(dataType: decodeDataType.self, url: url) { [weak self] result in
            completion(self?.lift(response: result) ?? .failure(.instanceDeath))
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
