//
//  ImageCachable.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit

public protocol ImageCachable {
    
    typealias CacheResult<T> = (Result<T, ImageCacheError>)
    typealias CacheCompletion<T> = (CacheResult<T>) -> ()
    
    func insert(image: UIImage?, for url: URL) -> ImageCacheError?
    
    func remove(for url: URL)
    
    func image(for url: URL, completion: CacheCompletion<UIImage>)
}
