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
    
    case image(indexPaths: [IndexPath], imageSize: CGSize, _ completion: ((UIImage) -> ())?)
    
    case clickOn(indexRow: Int)
}

class PokemonListView: BaseView {

    // MARK: -
    // MARK: Variables
    
    public let statesHandler = PublishSubject<PokemonListViewStates>()
    
    @IBOutlet weak var tableView: UITableView?
    
    private lazy var adapter: TableAdapter = {
        TableAdapter(tableView: self.tableView, cells: [PokemonListTableCell.self])
    }()
    
    // MARK: -
    // MARK: Public
    
    override func prepareBinding(disposeBag: DisposeBag) {
        self.adapter.statesHandler.bind { [weak self] events in
            self?.handle(events: events)
        }.disposed(by: disposeBag)
    }
    
    public func update() {
        self.statesHandler.onNext(.pokemons({ pokemons in
            let section = Section(cell: PokemonListTableCell.self, models: pokemons)
            self.adapter.sections.append(section)
            
        }))
    }
    
    // MARK: -
    // MARK: Private
    
    private func handle(events: TableEvents) {
        switch events {
        case .didSelect(indexPath: let indexPath):
            self.statesHandler.onNext(.clickOn(indexRow: indexPath.row))
            
            self.tableView?.deselectRow(at: indexPath, animated: true)
            
        case .handleCellEvents(at: let indexPath, events: let events):
            if let events = events as? PokemonListCellEvents {
                switch events {
                case .image(let size, let completion):
                    self.statesHandler.onNext(.image(indexPaths: [indexPath], imageSize: size, { image in
                        completion(image)
                    }))
                }
            }
        }
    }
}



