//
//  PokemonListTableCell.swift
//  pokemon_table
//
//  Created by mac on 18.01.2022.
//

import UIKit

public enum PokemonListCellEvents {
    
    case image(size: CGSize, completion: (UIImage) -> ())
}

class PokemonListTableCell: BaseCell<Pokemon, PokemonListCellEvents> {
    
    // MARK: -
    // MARK: Variables
    
    @IBOutlet weak var avatar: UIImageView?
    @IBOutlet weak var name: UILabel?
    
    // MARK: -
    // MARK: Cell Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.avatar?.image = nil
        self.name?.text = nil
    }
    
    // MARK: -
    // MARK: Overriden
    
    override func fill(with model: Pokemon) {
        self.name?.text = model.name
        
        self.eventHandler?(.image(size: self.avatar!.frame.size, completion: {
            self.avatar?.image = $0
        }))
    }
}
