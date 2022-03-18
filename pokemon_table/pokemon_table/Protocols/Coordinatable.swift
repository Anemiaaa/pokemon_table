//
//  Coordinatable&Presentable.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit
import RxSwift

public protocol Coordinatable: UIViewController {
    
    var childCoordinators: [Coordinatable] { get set }
    
    func start()
}

public class BaseCoordinator: UIViewController, Coordinatable {
    
    // MARK: -
    // MARK: Variables
    
    public var childCoordinators: [Coordinatable] = []
    
    public weak var navigation: UINavigationController?

    // MARK: -
    // MARK: Initialization
    
    public init(navigationController: UINavigationController) {
        self.navigation = navigationController
        
        super.init(nibName: nil, bundle: nil)
        
        self.start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Public
    
    public func start() {
        fatalError("start() has not been implemented")
    }
}
