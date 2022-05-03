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
    
    public static func lift<Value>(_ value: Value) -> () -> Value {
        return { value }
    }
    
    public static func identity<Value>(_ value: Value) -> Value {
        return value
    }
}
