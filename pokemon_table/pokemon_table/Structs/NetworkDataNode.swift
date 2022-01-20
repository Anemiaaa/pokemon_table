//
//  NetworkDataNode.swift
//  pokemon_table
//
//  Created by mac on 13.01.2022.
//

import Foundation

public struct NetworkDataNode<ContainedObjectType: Codable>: Codable {
    
    var count: Int
    var next: URL?
    var previous: URL?
    var results: ContainedObjectType
}
