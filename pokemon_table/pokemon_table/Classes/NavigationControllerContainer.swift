//
//  NavigationControllerContainer.swift
//  pokemon_table
//
//  Created by mac on 20.02.2022.
//

import Foundation
import UIKit

public class NavigationControllerContainer<Presenter: Coordinatable>: UINavigationController {
    
    // MARK: -
    // MARK: Variables
    
    public var presenter: Coordinatable? {
        didSet {
            if let presenter = self.presenter {
                self.viewControllers.removeAll()
                self.pushViewController(presenter, animated: false)
            }
        }
    }
    
    // MARK: -
    // MARK: Initialization
    
    public init(presenter: Presenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
