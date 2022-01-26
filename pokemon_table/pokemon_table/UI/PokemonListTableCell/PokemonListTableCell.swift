//
//  PokemonListTableCell.swift
//  pokemon_table
//
//  Created by mac on 18.01.2022.
//

import UIKit

class PokemonListTableCell: UITableViewCell, PokemonCell {
    
    // MARK: -
    // MARK: Variables
    
    @IBOutlet weak var avatar: UIImageView?
    @IBOutlet weak var name: UILabel?
    
    // MARK: -
    // MARK: Overriden
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.avatar?.image = nil
        self.name?.text = nil
    }
}
