//
//  LandingCoordinator.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit

public class LandingCoordinator: BaseCoordinator {
    
    // MARK: -
    // MARK: Variables
    
    
    private let api: PokemonAPI
    private var controllers: [UIViewController] = []
    
    // MARK: -
    // MARK: Initialization
    
    public required init(api: PokemonAPI) {
        self.api = api
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Public
    
    override public func start() {
        let landingViewController = PokemonListViewController(api: self.api)
        self.controllers.append(landingViewController)
      
        self.prepareObserving()
        
        self.navigationController?.pushViewController(landingViewController, animated: true)
    }
    
    // MARK: -
    // MARK: Private
    
    private func prepareObserving() {
        
        self.controllers.forEach{ controller in
            if let controller = controller as? PokemonListViewController {
                controller.coordinator.bind(onNext: { [weak self] states in
                    switch states {
                    case .detail(pokemon: let pokemon):
                        if let api = self?.api {
                            let detailController = DetailPokemonViewController(api: api, pokemon: pokemon)
                            
                            self?.navigationController?.pushViewController(detailController, animated: true)
                        }
                    }
                })
            }
        }
    }
    
}
