//
//  F.swift
//  pokemon_table
//
//  Created by mac on 19.01.2022.
//

import Foundation
import RxSwift

public enum F {
    
    public typealias Handler<T> = (T) -> ()

    typealias PokemonResult<T, ErrorType: Error> = (Result<T, ErrorType>)
    typealias PokemonCompletion<T, ErrorType: Error> = (PokemonResult<T, ErrorType>) -> ()
}

public func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { a in
        { b in { f(a, b, $0) } }
    }
}

public func flip<A, B, Result>(_ f: @escaping (A, B) -> Result) -> (B, A) -> Result {
    return { f($1, $0) }
}

public func flip<A, B, C, Result>(_ f: @escaping (A, B, C) -> Result) -> (C, B, A) -> Result {
    return { f($2, $1, $0) }
}
