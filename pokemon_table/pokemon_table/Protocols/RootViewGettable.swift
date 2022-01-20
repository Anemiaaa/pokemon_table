//
//  RootViewGettable.swift
//  pokemon_table
//
//  Created by mac on 18.01.2022.
//

import Foundation
import UIKit

protocol RootViewGettable {
    
    associatedtype View: UIView
    
    var rootView: View? { get }
}

extension RootViewGettable where Self: UIViewController {
    
    var rootView: View? {
        return self.viewIfLoaded as? View
    }
}
