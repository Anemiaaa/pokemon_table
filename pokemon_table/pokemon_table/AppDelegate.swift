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
    var navigationContainer: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let api = PokemonNetworkAPI<UrlSessionService>(
            imageCacher: ImageCacher(config: ConfigCacher.default)
        )
        
        let navigation = NavigationControllerContainer()
        let coordinator = LandingCoordinator(api: api, navigationController: navigation)
        
        navigation.presenter = coordinator
        
        window.rootViewController = navigation

        self.navigationContainer = navigation
        self.window = window
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

