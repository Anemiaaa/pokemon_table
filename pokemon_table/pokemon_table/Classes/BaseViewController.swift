//
//  BaseViewController.swift
//  pokemon_table
//
//  Created by mac on 09.02.2022.
//

import Foundation
import UIKit
import RxSwift

public class BaseViewController<T: BaseView>: UIViewController, RootViewGettable {
    
    public typealias View = T
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rootView?.configure()
    }
}
