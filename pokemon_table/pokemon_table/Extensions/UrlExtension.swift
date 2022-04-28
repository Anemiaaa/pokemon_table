//
//  UrlExtension.swift
//  pokemon_table
//
//  Created by Yana on 21/04/2022.
//

import Foundation

infix operator +?: AdditionPrecedence

public extension URL {
    
    static func + (left: URL, right: String) -> URL {
        return left.appendingPathComponent(right)
    }
    
    static func +? (left: URL, right: [String: Any]) -> URL {
        guard var urlComponents = URLComponents(string: left.absoluteString) else {
            return left.absoluteURL
        }
        
        urlComponents.queryItems = right.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        guard let resultURL = urlComponents.url else {
            return left.absoluteURL
        }
        
        return resultURL
    }
}
