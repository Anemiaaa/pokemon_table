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
    func pokemons(count: Int, completion: @escaping PokemonCompletion<NetworkDataNode<[Pokemon]>>) -> URLSessionDataTask?
    
    @discardableResult
    func features(pokemon: Pokemon, completion: @escaping PokemonCompletion<PokemonFeatures>) -> URLSessionDataTask?
    
    @discardableResult
    func effect(of ability: PokemonAbility, completion: @escaping PokemonCompletion<EffectEntry>) -> URLSessionDataTask?
    
    @discardableResult
    func image(features: PokemonFeatures, imageType: PokemonImageTypes, size: CGSize, completion: @escaping PokemonCompletion<UIImage>) -> URLSessionDataTask?
}
