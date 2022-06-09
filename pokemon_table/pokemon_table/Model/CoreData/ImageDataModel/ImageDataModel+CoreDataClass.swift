//
//  ImageDataModel+CoreDataClass.swift
//  
//
//  Created by Yana on 09/06/2022.
//
//

import Foundation
import CoreData

@objc(ImageDataModel)
public class ImageDataModel: NSManagedObject {

    public convenience init(context: NSManagedObjectContext, url: URL?, imageData: Data?) {
        self.init(context: context)
        self.url = url
        self.imageData = imageData
    }
}
