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

//public extension NetworkService {
//
//    static func request<ModelType>(
//        model: ModelType.Type,
//        url: URL? = nil
//    )
//        -> Request<ModelType, Self> where ModelType: NetworkProcessable
//    {
//        return Request(modelType: model, url: url ?? model.url)
//    }
//
//    static func request<ModelType, Params: QueryParamsType>(
//        model: ModelType.Type,
//        params: Params
//    )
//        -> Request<ModelType, Self> where ModelType: NetworkProcessable
//    {
//        self.request(model: model, params: params, url: nil)
//    }
//
//    static func request<ModelType, Params: QueryParamsType>(
//        model: ModelType.Type,
//        params: Params,
//        url: URL? = nil
//    )
//        -> Request<ModelType, Self> where ModelType: NetworkProcessable
//    {
//        let encoder = JSONEncoder()
//        let data = (try? encoder.encode(params)) ?? Data()
//
//        let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String : Any]
//
//        let url = (url ?? model.url) +? (dictionary ?? [:])
//
//        return Request(modelType: model, url: url)
//    }
//}
