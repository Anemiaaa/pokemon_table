//
//  PokemonAPI.swift
//  pokemon_table
//
//  Created by mac on 18.01.2022.
//

import Foundation

public protocol PokemonAPI {

    func pokemons(count: Int, completion: @escaping F.PokemonCompletion<NetworkDataNode<[Pokemon]>>)
    
    func features(pokemon: Pokemon, completion: @escaping F.PokemonCompletion<PokemonFeatures>)
    
    func effect(of ability: PokemonAbility, completion: @escaping F.PokemonCompletion<AbilityEffects>)
    
    func images(pokemon: Pokemon, imageType: PokemonImageTypes, completion: @escaping F.PokemonCompletion<Data>)
}
