//
//  BaseViewController.swift
//  pokemon_table
//
//  Created by mac on 09.02.2022.
//

import Foundation
import UIKit
import RxSwift

public class BaseViewController<T>: UIViewController where T: RootViewGettable, T.View: BaseView {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let self = self as? T {
            self.rootView?.configure()
        }
    }
}
