//
//  Networking.swift
//  pokemon_table
//
//  Created by mac on 28.01.2022.
//

import Foundation

public protocol NetworkService {
    
    typealias NetworkResult<ModelType: Codable> = Result<ModelType, Error>
    typealias NetworkResponse<ModelType: Codable> = (NetworkResult<ModelType>) -> ()
    
    @discardableResult
    static func dataTask<ModelType: NetworkProcessable>(
        url: URL,
        modelType: ModelType.Type,
        completion: @escaping NetworkResponse<ModelType.ReturnedType>
    ) -> Task
    
    @discardableResult
    static func dataTask(
        url: URL,
        completion: @escaping NetworkResponse<Data>
    ) -> Task
}
