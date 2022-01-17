//
//  NetworkHelper.swift
//  pokemon_table
//
//  Created by mac on 13.01.2022.
//

import Foundation

public typealias NetworkResult<DataType: Codable> = Result<Codable, Error>
public typealias NetworkResponse<DataType: Codable> = (NetworkResult<DataType>) -> ()

public class NetworkHelper {
    
    public static func data<DataType: Codable>(url: URL, completion: NetworkResponse<DataType>) -> NetworkDataNode<DataType> {
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            if let data = data {
                 let 
            }
        }
    }
}
