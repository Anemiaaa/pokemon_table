//
//  PokemonListView.swift
//  pokemon_table
//
//  Created by mac on 18.01.2022.
//

import UIKit
import RxSwift

public enum PokemonListViewStates {
    
    case pokemons(_ completion: ([Pokemon]) -> ())
    case image(pokemon: Pokemon, imageType: PokemonImageTypes, _ completion: (UIImage) -> ())
    case clickOn(indexRow: Int)
}

class PokemonListView: UIView {

    // MARK: -
    // MARK: Variables
    
    public let statesHandler = PublishSubject<PokemonListViewStates>()
    
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: -
    // MARK: Overriden
    
    override func awakeFromNib() {
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.tableView?.register(cell: PokemonListTableCell.self)
    }

}

extension PokemonListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        self.statesHandler.onNext(.pokemons({
            count = $0.count
        }))
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView?.dequeueReusableCell(
            withIdentifier: PokemonListTableCell.id(),
            for: indexPath)
            as? PokemonListTableCell
        {
            
            var pokemon: Pokemon?
            self.statesHandler.onNext(.pokemons({ pokemon = $0[indexPath.row] }))
            
            cell.name?.text = pokemon?.name
            
            if let pokemon = pokemon {
                self.statesHandler.onNext(.image(pokemon: pokemon, imageType: .frontDefault, { image in
                    cell.avatar?.image = image
                }))
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.statesHandler.onNext(.clickOn(indexRow: indexPath.row))
    }
}

