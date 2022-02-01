//
//  NavigateViewControllerDelegate.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit

public protocol NavigateViewControllerDelegate: AnyObject {
    
    func navigateToNextPage(_ data: Any?)
    
    func backToPreviousPage()
}

extension NavigateViewControllerDelegate where Self: Coordinatable {
    
    public func backToPreviousPage() {
        self.navigationController.popToRootViewController(animated: true)
        self.childCoordinators.removeLast()
    }
}
