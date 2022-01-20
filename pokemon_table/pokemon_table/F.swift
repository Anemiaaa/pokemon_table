//
//  F.swift
//  pokemon_table
//
//  Created by mac on 19.01.2022.
//

import Foundation

public enum F {

    public typealias PokemonResult<T> = Result<T, PokemonApiError>
    public typealias PokemonCompletion<T> = (PokemonResult<T>) -> ()
}
