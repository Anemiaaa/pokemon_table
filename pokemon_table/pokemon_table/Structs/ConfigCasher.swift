//
//  ConfigCasher.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation

public struct ConfigCacher {
    
    static let `default` = ConfigCacher(
        countLimit: 100,
        memoryLimit: 1024 * 1024 * 100
    )
    
    let countLimit: Int
    let memoryLimit: Int
}
