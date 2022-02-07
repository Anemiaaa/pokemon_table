//
//  ImageCacher.swift
//  pokemon_table
//
//  Created by mac on 31.01.2022.
//

import Foundation
import UIKit

public enum ImageCacheError: Error {

    case imageNotExist
    case cacheError
}

public class Cacher<Key: AnyObject, Value: AnyObject>: Cachable {
  
    // MARK: -
    // MARK: Variables
    
    private var cache = NSCache<Key, Value>()
    
    private let config: ConfigCacher
    
    // MARK: -
    // MARK: Initialization
    
    public init(config: ConfigCacher) {
        self.config = config
        
        self.cache.countLimit = config.countLimit
    }
    
    // MARK: -
    // MARK: Public
    
    public func insert(value: Value, for key: Key)  {
        self.cache.setObject(value, forKey: key)
    }
    
    public func remove(for key: Key) {
        self.cache.removeObject(forKey: key)
    }
    
    public func cachedData(for key: Key) -> Value? {
        return self.cache.object(forKey: key)
    }
}
