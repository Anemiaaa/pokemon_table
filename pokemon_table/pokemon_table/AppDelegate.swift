//
//  AppDelegate.swift
//  pokemon_table
//
//  Created by mac on 12.01.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationContainer: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let api = PokemonNetworkAPI(
            nodeSettings: NodeSettings.default,
            service: NetworkHelper(),
            imageCacher: ImageCacher(config: ConfigCacher.default)
        )
        
        let manager = PokemonManager(
            api: api,
            coreDataManager: CoreDataManager(context: self.persistentContainer.viewContext),
            imageCacher: ImageCacher(config: ConfigCacher.default)
        )
        
        let navigation = NavigationControllerContainer()
        let coordinator = LandingCoordinator(api: manager, navigationController: navigation)
        
        navigation.presenter = coordinator
        
        window.rootViewController = navigation

        self.navigationContainer = navigation
        self.window = window
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: -
    // MARK: Core Data
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

