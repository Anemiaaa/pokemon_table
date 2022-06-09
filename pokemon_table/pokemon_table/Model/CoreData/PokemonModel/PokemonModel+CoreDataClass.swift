//
//  PokemonModel+CoreDataClass.swift
//  
//
//  Created by Yana on 09/06/2022.
//
//

import Foundation
import CoreData


public class PokemonModel: NSManagedObject, ManagedObject {

    public typealias ModelType = Pokemon

    public func setFields(model: Pokemon, context: NSManagedObjectContext) {
        self.id = model.id
        self.name = model.name
        self.url = model.url
        
        if let number = self.numberInOrder(by: model.url) {
            self.numberInOrder = Int64(number)
        }
    }

    private func numberInOrder(by url: URL) -> Int? {
        let lastComponentNumber = url.pathComponents.count - 1
        
        if let number = url.pathComponents[lastComponentNumber].components(separatedBy: "/").first {
            return Int(number)
        }
        return nil
    }
}
