//
//  RootViewGettable.swift
//  pokemon_table
//
//  Created by mac on 18.01.2022.
//

import Foundation
import UIKit

public protocol RootViewGettable: AnyObject {
    
    associatedtype View: UIView
    
    var rootView: View? { get }
}

extension RootViewGettable where Self: UIViewController {
    
    public var rootView: View? {
        return self.viewIfLoaded as? View
    }
}
