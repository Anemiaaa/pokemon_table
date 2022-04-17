//
//  BaseView.swift
//  pokemon_table
//
//  Created by mac on 09.02.2022.
//

import Foundation
import UIKit
import RxSwift

public class BaseView: UIView {
    
    public weak var controller: BaseViewController<BaseView>?
    
    public func configure() {}
    
    public func prepareBinding(disposeBag: DisposeBag) {}
}

