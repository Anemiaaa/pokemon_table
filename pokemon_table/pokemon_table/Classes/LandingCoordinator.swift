//
//  LandingCoordinator.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit
import RxSwift

public class LandingCoordinator: BaseCoordinator {
    
    // MARK: -
    // MARK: Variables
    
    private let api: PokemonAPI
    private let disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: Initialization
    
    public required init(api: PokemonAPI, navigationController: UINavigationController) {
        self.api = api
        
        super.init(navigationController: navigationController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Public
    
    override public func start() {
        self.showPokemonListController()
    }
    
    // MARK: -
    // MARK: Private
    
    private func showPokemonListController() {
        let controller = PokemonListViewController(api: self.api)
        
        controller.events.bind { [weak self] states in
            self?.handle(events: states)
        }.disposed(by: self.disposeBag)
        
        self.navigation?.pushViewController(controller, animated: true)
    }
    
    private func handle(events: PokemonListControllerStates) {
        switch events {
        case .detail(let pokemon):
            self.showDetailController(pokemon: pokemon)
        }
    }
    
    private func showDetailController(pokemon: Pokemon) {
        let detailController = DetailPokemonViewController(api: self.api, pokemon: pokemon)
        
        self.navigation?.pushViewController(detailController, animated: true)
    }
}


