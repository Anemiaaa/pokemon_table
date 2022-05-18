//
//  PokemonAPI.swift
//  pokemon_table
//
//  Created by mac on 18.01.2022.
//

import Foundation
import UIKit

public protocol PokemonAPI {
    
    typealias PokemonResult<T> = Result<T, PokemonApiError>
    typealias PokemonCompletion<T> = (PokemonResult<T>) -> ()

    @discardableResult
    func pokemons(count: Int, completion: @escaping PokemonCompletion<NetworkDataNode>) -> Task?
    
    @discardableResult
    func image(
        features: PokemonFeatures,
        imageType: PokemonImageTypes,
        size: CGSize,
        completion: @escaping PokemonCompletion<UIImage>
    ) -> Task?

    @discardableResult
    func data<T: NetworkProcessable>(url: URL, model: T.Type, completion: @escaping PokemonCompletion<T.ReturnedType>) -> Task?
}

extension PokemonAPI {
    public func url(from features: PokemonFeatures, to type: PokemonImageTypes) -> URL? {
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
