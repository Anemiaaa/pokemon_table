//
//  ImageDataModel+CoreDataProperties.swift
//  
//
//  Created by Yana on 09/06/2022.
//
//

import Foundation
import CoreData


extension ImageDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageDataModel> {
        return NSFetchRequest<ImageDataModel>(entityName: "ImageDataModel")
    }

    @NSManaged public var url: URL?
    @NSManaged public var imageData: Data?

}
