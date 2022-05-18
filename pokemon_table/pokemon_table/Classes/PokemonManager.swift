//
//  PokemonManager.swift
//  pokemon_table
//
//  Created by Yana on 16/05/2022.
//

import Foundation
import UIKit
import CoreData

public class PokemonManager: PokemonAPI {

    // MARK: -
    // MARK: Variables

    private let api: PokemonAPI
    private let context: NSManagedObjectContext?

    // MARK: -
    // MARK: Initialization

    public init(api: PokemonAPI) {
        self.api = api
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }

    // MARK: -
    // MARK: Public

    public func pokemons(count: Int, completion: @escaping PokemonCompletion<NetworkDataNode>) -> Task? {
        self.deleteAllData("PokemonModel")
        do {
            if let coreDataNodes = try self.context?.fetch(NetworkDataNodeModel.fetchRequest()),
               let coreDataNode = coreDataNodes.first
            {
                completion(.success(NetworkDataNode.init(coreDataModel: coreDataNode)))
            }
        }
        catch {
            fatalError("Fetch Error")
        }
        
        return self.api.pokemons(count: count) { [weak self] pokemons in
            self?.save(pokemons: pokemons, completion: {
                completion($0)
            })
        }
    }
    
    public func image(features: PokemonFeatures, imageType: PokemonImageTypes, size: CGSize, completion: @escaping PokemonCompletion<UIImage>) -> Task? {
        self.api.image(
            features: features,
            imageType: imageType,
            size: size
        ) {
            completion($0)
        }
    }
    
    public func data<T>(url: URL, model: T.Type, completion: @escaping PokemonCompletion<T.ReturnedType>) -> Task? where T : NetworkProcessable {
        do {
            return self.api.data(url: url, model: model) { [weak self] result in
                let request = PokemonModel.fetchRequest()
                
                request.predicate = NSPredicate(format: "url == %@", url as CVarArg)
                let pokemon = try? self?.context?.fetch(request).first
                let result = try? result.get()
    
                
                try? self?.context?.save()
            }
        }
        catch {}
    }
    
    // MARK: -
    // MARK: Private
    
    private func save(pokemons: PokemonResult<NetworkDataNode>, completion: PokemonCompletion<NetworkDataNode>) {
        do {
            let node = try pokemons.get()
            
            if let context = self.context {
                let nodeModel = NetworkDataNodeModel(context: context)
                
                nodeModel.count = Int64(node.count)
                nodeModel.next = node.next
                nodeModel.previous = node.previous
                
                node.results.forEach { pokemon in
                    let pokemonModel = PokemonModel(context: context)
                    
                    pokemonModel.id = pokemon.id
                    pokemonModel.name = pokemon.name
                    pokemonModel.url = pokemon.url
                    
                    nodeModel.addToResults(pokemonModel)
                }
                
                try context.save()
            }
        }
        catch {
            fatalError("Error save to CoreData")
        }
        
        completion(pokemons)
    }
    
    private func deleteAllData(_ entity:String) {
        guard let context = self.context else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}
