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

    func pokemons(count: Int, completion: @escaping PokemonCompletion<NetworkDataNode<[Pokemon]>>)
    
    func features(pokemon: Pokemon, completion: @escaping PokemonCompletion<PokemonFeatures>)
    
    func effect(of ability: PokemonAbility, completion: @escaping PokemonCompletion<EffectEntry>)
    
    func image(pokemon: Pokemon, imageType: PokemonImageTypes, completion: @escaping PokemonCompletion<UIImage>)
}
