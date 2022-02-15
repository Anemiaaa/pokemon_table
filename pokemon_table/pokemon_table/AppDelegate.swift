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
    
        let coordinator = LandingCoordinator(api: PokemonNetworkAPI())
        
        window.rootViewController = coordinator.navigationController

        self.window = window
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

