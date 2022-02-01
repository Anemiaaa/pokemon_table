//
//  Coordinatable&Presentable.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit

public protocol Coordinatable: AnyObject {
    
    var childCoordinators: [Coordinatable] { get set }
    
    var navigationController: UINavigationController { get }
    
    func start()
}
    
