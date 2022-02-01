//
//  LandingCoordinator.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit

public class LandingCoordinator: Coordinatable {
    
    // MARK: -
    // MARK: Variables
    
    public var childCoordinators: [Coordinatable] = []
    public let navigationController: UINavigationController
    
    private let api: PokemonAPI
    private weak var viewController: UIViewController?
    
    // MARK: -
    // MARK: Initialization
    
    public required init(navigationController: UINavigationController, api: PokemonAPI) {
        self.navigationController = navigationController
        self.api = api
    }
    
    public func start() {
        let landingViewController = PokemonListViewController(api: self.api)
        self.viewController = landingViewController
        
        landingViewController.delegate = self
        
        self.navigationController.viewControllers = [landingViewController]
    }
}

extension LandingCoordinator: NavigateViewControllerDelegate {
    
    public func navigateToNextPage(_ data: Any?) {
        guard let pokemon = data as? Pokemon else {
            self.viewController?.showAlert(title: "Error data", message: nil)
            return
        }
        let nextController = DetailPokemonViewController(api: self.api, pokemon: pokemon)
        nextController.delegate = self
        
        self.navigationController.pushViewController(nextController, animated: true)
    }
}
