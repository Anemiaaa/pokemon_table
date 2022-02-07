//
//  ImageCacher.swift
//  pokemon_table
//
//  Created by mac on 07.02.2022.
//

import Foundation
import UIKit

public class ImageCacher: Cacher<NSURL, NSData> {
    
    public func downsample(data: NSData, to size: CGSize) -> UIImage {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let source = CGImageSourceCreateWithData(data as CFData, sourceOptions)
        
        let options = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ] as CFDictionary
        
        if let source = source, let downsampledImage = CGImageSourceCreateImageAtIndex(source, 0, options) {
            return UIImage(cgImage: downsampledImage)
        }
        return UIImage()
    }
}
