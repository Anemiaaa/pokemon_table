//
//  PokemonCell.swift
//  pokemon_table
//
//  Created by mac on 19.01.2022.
//

import Foundation
import UIKit

protocol PokemonCell where Self: UITableViewCell {
    
    var avatar: UIImageView? { get set }
    var name: UILabel? { get set }
}

protocol PokemonCustomTableView {
    
    associatedtype Cell: PokemonCell
}
