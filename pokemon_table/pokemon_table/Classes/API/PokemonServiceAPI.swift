//
//  PokemonServiceAPI.swift
//  pokemon_table
//
//  Created by Yana on 21/04/2022.
//

import Foundation
import UIKit

public class PokemonServiceAPI<Service: NetworkService>: PokemonAPI {
    
    private let imageCashe: ImageCachable
    
    // MARK: -
    // MARK: Initialization
    
    public init(imageCacher: ImageCachable) {
        self.imageCashe = ImageCacher(config: ConfigCacher.default)
    }
    
    // MARK: -
    // MARK: Public
    
    public func pokemons(count: Int, completion: @escaping PokemonCompletion<NetworkDataNode<[Pokemon]>>) -> Task? {
        Service.request(model: Pokemon.self, params: count) |*| get {
            
        }
    }
    
    public func effect(of ability: PokemonAbility, completion: @escaping PokemonCompletion<EffectEntry>) -> Task? {
        Service.request(model: EffectEntry.self, url: ability.effectURL) |*| get { response in
            
        }
    }
    
    public func image(url: URL, size: CGSize, completion: @escaping PokemonCompletion<UIImage>) -> Task? {
        <#code#>
    }
}
