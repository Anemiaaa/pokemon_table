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
    case anotherError(Error)
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
    
    private let networkHelper: Networking
    private let imageCashe: ImageCacher
    
    // MARK: -
    // MARK: Initialization
    
    public init(network: Networking, imageCacher: ImageCacher) {
        self.networkHelper = NetworkHelper(session: URLSession.shared)
        self.imageCashe = ImageCacher(config: ConfigCacher.default)
    }
    
    // MARK: -
    // MARK: Public
    
    @discardableResult
    public func pokemons(count: Int, completion: @escaping PokemonCompletion<NetworkDataNode<[Pokemon]>>) -> URLSessionDataTask? {
        guard count > 0 else {
            completion(.failure(.incorrectInputFormat))
            return nil
        }
        guard let url = URL(string: Links.random + String(count)) else {
            completion(.failure(.urlInit))
            return nil
        }

        return self.networkData(from: NetworkDataNode<[Pokemon]>.self, url: url) {
            completion($0)
        }
    }
    
    @discardableResult
    public func features(pokemon: Pokemon, completion: @escaping PokemonCompletion<PokemonFeatures>) -> URLSessionDataTask? {
        return self.networkData(from: PokemonFeatures.self, url: pokemon.url) {
            completion($0)
        }
    }
    
    @discardableResult
    public func effect(of ability: PokemonAbility, completion: @escaping PokemonCompletion<EffectEntry>) -> URLSessionDataTask? {
        return self.networkData(from: EffectEntry.self, url: ability.url) {
            completion($0)
        }
    }
    
    @discardableResult
    public func image(
        features: PokemonFeatures,
        imageType: PokemonImageTypes,
        size: CGSize,
        completion: @escaping PokemonCompletion<UIImage>) -> URLSessionDataTask?
    {
        guard let url = self.url(from: features, to: imageType) else {
            completion(.failure(.imageNotExist))
            return nil
        }
        
        if let imageData = self.imageCashe.cachedData(for: url as NSURL) {
            completion(.success(self.imageCashe.downsample(data: imageData, to: size)))
            return nil
        }

        return self.networkHelper.image(url: url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageCashe.insert(value: imageData as NSData, for: url as NSURL)
                
                completion(.success(self?.imageCashe.downsample(data: imageData as NSData, to: size) ?? UIImage()))
            case .failure(let error):
                completion(.failure(.anotherError(error)))
            }
        }
    }
    
    // MARK: -
    // MARK: Private

    private func lift<T, ErrorType>(response: Result<T, ErrorType>) -> PokemonResult<T> {
        switch response {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(.anotherError(error))
        }
    }
    
    private func networkData<T: Codable> (
        from decodeDataType: T.Type,
        url: URL,
        completion: @escaping PokemonCompletion<T>) -> URLSessionDataTask?
    {
        return self.networkHelper.data(dataType: decodeDataType.self, url: url) { [weak self] result in
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
