//
//  NetworkProcessable.swift
//  pokemon_table
//
//  Created by Yana on 17/04/2022.
//

import Foundation

public protocol NetworkProcessable: DataInitiable, Codable {
    
    associatedtype ReturnedType: Codable = Self
    
    static var url: URL { get }
    
    static func initialize(
        with data: Result<Data, Error>
    ) -> Result<ReturnedType, Error>
    
    static func dataInitialize(with data: Result<Data, Error>) -> Result<ReturnedType, Error>
}

public extension NetworkProcessable {
    static func initialize(with data: Result<DataType, Error>) -> Result<ReturnedType, Error> {
        dataInitialize(with: data)
    }
    
    static func dataInitialize(with data: Result<Data, Error>) -> Result<ReturnedType, Error> {
        do {
            let data = try data.get()
            let decoded = try JSONDecoder().decode(ReturnedType.self, from: data)
            
            return .success(decoded)
        } catch {
            switch data {
            case let .failure(error):
                return .failure(error)
            default:
                return .failure(error)
            }
        }
    }
}
