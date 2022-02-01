//
//  AppDelegate.swift
//  pokemon_table
//
//  Created by mac on 12.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
    
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        let coordinator = LandingCoordinator(navigationController: navigationController, api: PokemonNetworkAPI())
        coordinator.start()
        
        self.window = window
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

