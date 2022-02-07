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
    
    case image(indexPath: IndexPath, imageSize: CGSize, _ completion: (UIImage) -> ())
    
    case prefetch(indexPaths: [IndexPath], imageSize: CGSize)
    
    case stopLoadAt(indexPaths: [IndexPath])
    
    case clickOn(indexRow: Int)
}

class PokemonListView: UIView {

    // MARK: -
    // MARK: Variables
    
    public let statesHandler = PublishSubject<PokemonListViewStates>()
    
    private var prefetchedImages: [IndexPath: UIImage] = [:]
    
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: -
    // MARK: Overriden
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.prefetchDataSource = self
        
        self.tableView?.register(cell: PokemonListTableCell.self)
        
        self.tableView?.estimatedRowHeight = 100
    }

}

extension PokemonListView: UITableViewDataSource {
    
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
            
            self.statesHandler.onNext(.pokemons({ cell.name?.text = $0[indexPath.row].name }))
            
            if let size = cell.avatar?.frame.size {
                self.statesHandler.onNext(.image(
                    indexPath: indexPath,
                    imageSize: size,
                    { cell.avatar?.image = $0 }
                ))
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

extension PokemonListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.statesHandler.onNext(.clickOn(indexRow: indexPath.row))
        
        self.tableView?.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.statesHandler.onNext(.stopLoadAt(indexPaths: [indexPath]))
    }
}

extension PokemonListView: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let cell = self.tableView?.visibleCells[0] as? PokemonListTableCell,
           let size = cell.avatar?.frame.size
        {
            self.statesHandler.onNext(.prefetch(indexPaths: indexPaths, imageSize: size))
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        self.statesHandler.onNext(.stopLoadAt(indexPaths: indexPaths))
    }
}

