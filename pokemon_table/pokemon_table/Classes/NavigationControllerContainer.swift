//
//  NavigationControllerContainer.swift
//  pokemon_table
//
//  Created by mac on 20.02.2022.
//

import Foundation
import UIKit

public class NavigationControllerContainer: UINavigationController {
    
    // MARK: -
    // MARK: Variables
    
    public var presenter: Coordinatable?
    
    // MARK: -
    // MARK: Initialization
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
