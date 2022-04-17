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

public class Cacher<Key: ReferenceConvertible, Value: ReferenceConvertible>: Cachable 
{
  
    // MARK: -
    // MARK: Variables
    
    private var cache = NSCache<Key.ReferenceType, Value.ReferenceType>()
    
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
        guard let value = value as? Value.ReferenceType,
              let key = key as? Key.ReferenceType
        else {
            return
        }
        
        self.cache.setObject(value, forKey: key)
    }
    
    public func remove(for key: Key) {
        guard let key = key as? Key.ReferenceType else {
            return
        }
        self.cache.removeObject(forKey: key)
    }

    public func cachedData(for key: Key) -> Value? {
        guard let key = key as? Key.ReferenceType else {
            return nil
        }
        return self.cache.object(forKey: key) as? Value
    }
}

