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

    // MARK: -
    // MARK: Variables
    
    public typealias View = T
    
    private let disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rootView?.controller = self as? BaseViewController<BaseView>
        self.rootView?.prepareBinding(disposeBag: self.disposeBag)
        self.rootView?.configure()
        
        self.prepareObserving(disposeBag: self.disposeBag)
    }
    
    // MARK: -
    // MARK: Public
    
    public func prepareObserving(disposeBag: DisposeBag) {}
}
