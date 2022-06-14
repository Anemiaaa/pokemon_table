//
//  PokemonServiceAPI.swift
//  pokemon_table
//
//  Created by Yana on 21/04/2022.
//

import Foundation
import UIKit

struct PokemonBodyParams: BodyParamsType {
    
    var rawValues: [String : Int]
}

public class PokemonServiceAPI<Service: DataSessionService>: PokemonAPI {
    
    // MARK: -
    // MARK: Variables
    
    public let nodeSettings: NodeSettings
    
    private let imageCashe: ImageCachable
    
    // MARK: -
    // MARK: Initialization
    
    public init(imageCacher: ImageCachable, nodeSettings: NodeSettings) {
        self.imageCashe = ImageCacher(config: ConfigCacher.default)
        self.nodeSettings = nodeSettings
    }
    
    // MARK: -
    // MARK: Public
    
    public func pokemons(url: URL, completion: @escaping PokemonCompletion<NetworkDataNode>) -> Task? {
        self.data(url: url, model: Pokemon.self) {
            completion($0)
        }
    }
    
    public func pokemons(page: Int, completion: @escaping PokemonCompletion<NetworkDataNode>) -> Task? {
        let count = self.nodeSettings.count
        let bodyParams = PokemonBodyParams(rawValues: ["limit": count, "offset": count * (page - 1)])

        return Service.request(model: Pokemon.self, params:  bodyParams) |*| get { response in
            completion(self.lift(model: Pokemon.self, result: response))
        }
    }
    
    public func features(of pokemon: Pokemon, completion: @escaping PokemonCompletion<PokemonFeatures>) -> Task? {
        self.data(url: pokemon.url, model: PokemonFeatures.self) {
            completion($0)
        }
    }
    
    public func effect(of ability: PokemonAbility, completion: @escaping PokemonCompletion<EffectEntry>) -> Task? {
        self.data(url: ability.effectURL, model: EffectEntry.self) {
            completion($0)
        }
    }
    
    public func image(
        features: PokemonFeatures,
        imageType: PokemonImageTypes,
        size: CGSize,
        completion: @escaping PokemonCompletion<UIImage>
    ) -> Task? {
        guard let url = self.url(from: features, to: imageType) else {
            completion(.failure(.imageNotExist))
            return nil
        }
        
        if let imageData = self.imageCashe.cachedData(for: url) {
            completion(.success(self.imageCashe.downsample(data: imageData as Data, to: size)))
            return nil
        }
        
        return self.dataTask(url: url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageCashe.insert(value: imageData, for: url)
                
                completion(.success(self?.imageCashe.downsample(data: imageData, to: size) ?? UIImage()))
            case .failure(let error):
                completion(.failure(.anotherError(error)))
            }
        }
    }
    
    public func data<T>(url: URL, model: T.Type, completion: @escaping PokemonCompletion<T.ReturnedType>) -> Task? where T : NetworkProcessable {
        Service.request(model: model, url: url) |*| get { response in
            completion(self.lift(model: model, result: response))
        }
    }

    
    // MARK: -
    // MARK: Private
    
    private func lift<ModelType: NetworkProcessable>(
        model: ModelType.Type,
        result: Result<ModelType.ReturnedType, Error>
    ) -> PokemonResult<ModelType.ReturnedType>
    {
        switch result {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(.anotherError(error))
        }
    }
    
    private func dataTask(url: URL, completion: @escaping PokemonCompletion<Data>) -> Task? {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
              guard let data = data, error == nil else {
                  DispatchQueue.main.async {
                      completion(.failure(.anotherError(error!)))
                  }
                  return
              }
              DispatchQueue.main.async {
                  completion(.success(data))
              }
        }
        
        let task = UrlSessionTask(task: dataTask)
        task.resume()
        
        return task
    }
}
