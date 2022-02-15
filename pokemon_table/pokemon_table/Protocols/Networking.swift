//
//  Networking.swift
//  pokemon_table
//
//  Created by mac on 28.01.2022.
//

import Foundation

public protocol Networking {
    
    typealias NetworkResult<DataType: Codable> = Result<DataType, Error>
    typealias NetworkResponse<DataType: Codable> = (NetworkResult<DataType>) -> ()
    
    @discardableResult
    func data<DataType: Codable>(dataType: DataType.Type, url: URL, completion: @escaping NetworkResponse<DataType>) -> URLSessionDataTask
    
    @discardableResult
    func image(url: URL, completion: @escaping NetworkResponse<Data>) -> URLSessionDataTask
}
