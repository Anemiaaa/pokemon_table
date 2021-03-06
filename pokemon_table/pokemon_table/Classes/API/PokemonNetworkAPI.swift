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
    // MARK: Variables

    public let nodeSettings: NodeSettings
    
    private let service: NetworkService
    private let imageCashe: ImageCachable
    
    // MARK: -
    // MARK: Initialization
    
    public init(nodeSettings: NodeSettings, service: NetworkService, imageCacher: ImageCachable) {
        self.service = service
        self.nodeSettings = nodeSettings
        self.imageCashe = ImageCacher(config: ConfigCacher.default)
    }
    
    // MARK: -
    // MARK: Public
    
    @discardableResult
    public func pokemons(url: URL, completion: @escaping PokemonCompletion<NetworkDataNode>) -> Task? {
        return self.networkData(from: NetworkDataNode.self, url: url) {
            completion($0)
        }
    }
    
    @discardableResult
    public func pokemons(page: Int, completion: @escaping PokemonCompletion<NetworkDataNode>) -> Task? {
        guard self.nodeSettings.count > 0, page > 0 else {
            completion(.failure(.incorrectInputFormat))
            return nil
        }
        guard let baseURL = Pokemon.url else {
            completion(.failure(.urlInit))
            return nil
        }
        
        guard let url = self.urlComponents(page: page, baseURL: baseURL)?.url else {
            completion(.failure(.urlInit))
            return nil
        }
        
        return self.pokemons(url: url) {
            completion($0)
        }
    }
    
    @discardableResult
    public func image(
        features: PokemonFeatures,
        imageType: PokemonImageTypes,
        size: CGSize,
        completion: @escaping PokemonCompletion<UIImage>
    ) -> Task?
    {
        guard let url = self.url(from: features, to: imageType) else {
            completion(.failure(.imageNotExist))
            return nil
        }

        if let imageData = self.imageCashe.cachedData(for: url) {
            completion(.success(self.imageCashe.downsample(data: imageData as Data, to: size)))
            return nil
        }

        return self.service.dataTask(url: url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageCashe.insert(value: imageData, for: url)
                
                completion(.success(self?.imageCashe.downsample(data: imageData, to: size) ?? UIImage()))
            case .failure(let error):
                completion(.failure(.anotherError(error)))
            }
        }
    }

    public func features(of pokemon: Pokemon, completion: @escaping PokemonCompletion<PokemonFeatures>) -> Task? {
        self.networkData(from: PokemonFeatures.self, url: pokemon.url) {
            completion($0)
        }
    }
    
    public func effect(of ability: PokemonAbility, completion: @escaping PokemonCompletion<EffectEntry>) -> Task? {
        self.networkData(from: EffectEntry.self, url: ability.effectURL) {
            completion($0)
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
    
    private func networkData<T: NetworkProcessable> (
        from decodeDataType: T.Type,
        url: URL,
        completion: @escaping PokemonCompletion<T.ReturnedType>) -> Task?
    {
        return self.service.dataTask(url: url, modelType: decodeDataType.self) { [weak self] result in
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
