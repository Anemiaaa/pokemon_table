//
//  F.swift
//  pokemon_table
//
//  Created by mac on 19.01.2022.
//

import Foundation
import RxSwift

public enum F {

    typealias PokemonResult<T, ErrorType: Error> = (Result<T, ErrorType>)
    typealias PokemonCompletion<T, ErrorType: Error> = (PokemonResult<T, ErrorType>) -> ()
}
