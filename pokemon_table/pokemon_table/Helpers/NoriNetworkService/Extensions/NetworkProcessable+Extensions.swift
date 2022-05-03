//
//  NetworkProcessable+Extensions.swift
//  Network Service
//
//  Created by IDAP Developer on 12/3/19.
//  Copyright © 2019 Bendis. All rights reserved.
//

import Foundation

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
