//
//  NetworkDataNodeModel+CoreDataProperties.swift
//  
//
//  Created by Yana on 09/06/2022.
//
//

import Foundation
import CoreData


extension NetworkDataNodeModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NetworkDataNodeModel> {
        return NSFetchRequest<NetworkDataNodeModel>(entityName: "NetworkDataNodeModel")
    }

    @NSManaged public var count: Int64
    @NSManaged public var next: URL?
    @NSManaged public var previous: URL?
    @NSManaged public var results: NSSet?

}

// MARK: Generated accessors for results
extension NetworkDataNodeModel {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: PokemonModel)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: PokemonModel)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}
