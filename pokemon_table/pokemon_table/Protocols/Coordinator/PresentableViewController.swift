//
//  PresentableViewController.swift
//  pokemon_table
//
//  Created by mac on 01.02.2022.
//

import Foundation
import UIKit

public protocol PresentableViewController where Self: UIViewController {
    
    var delegate: NavigateViewControllerDelegate? { get set }
}
