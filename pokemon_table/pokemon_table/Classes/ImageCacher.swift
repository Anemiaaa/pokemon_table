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

public class ImageCacher: ImageCachable {
     
    // MARK: -
    // MARK: Variables
    
    private var imageCache = NSCache<AnyObject, AnyObject>()
    private var decodedImageCache = NSCache<AnyObject, AnyObject>()
    
    private let lock = NSLock()
    private let config: ConfigCacher
    
    // MARK: -
    // MARK: Initialization
    
    public init(config: ConfigCacher) {
        self.config = config
        
        self.imageCache.countLimit = config.countLimit
        self.decodedImageCache.totalCostLimit = config.memoryLimit
    }
    
    // MARK: -
    // MARK: Public
    
    public func insert(image: UIImage?, for url: URL) -> ImageCacheError? {
        guard let image = image else {
            return .imageNotExist
        }
        let decodedImage = image.decodedImage()
        
        self.lock.lock()
        
        self.imageCache.setObject(image, forKey: url as AnyObject)
        self.decodedImageCache.setObject(
            decodedImage,
            forKey: url as AnyObject
        )
        
        self.lock.unlock()
        
        return nil
    }
    
    public func remove(for url: URL) {
        self.lock.lock()
        
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
        
        self.lock.unlock()
    }
    
    public func image(for url: URL, completion: CacheCompletion<UIImage>) {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        
        if let decodedImage = self.decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(.success(decodedImage))
            return
        }
        
        if let image = self.imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            
            self.decodedImageCache.setObject(
                decodedImage,
                forKey: url as AnyObject
            )
            
            completion(.success(image))
        }
    }
}
