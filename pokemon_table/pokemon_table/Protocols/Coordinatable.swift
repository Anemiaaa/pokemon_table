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
    
    public var childCoordinators: [Coordinatable] = []
        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        UINavigationController(rootViewController: self)
        
        self.start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        fatalError("start() has not been implemented")
    }
}
