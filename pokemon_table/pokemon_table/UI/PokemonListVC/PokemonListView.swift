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
    
    case image(rows: [Int], imageSize: CGSize, _ completion: ((UIImage) -> ())?)
    
    case clickOn(indexRow: Int)
    
    case cellEndDisplaying(row: Int)
    
    case loadNextPage
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
    
    public func update(pokemons: [Pokemon]) {
        let section = Section(cell: PokemonListTableCell.self, models: pokemons)
        self.adapter.sections.append(section)
    }
    
    // MARK: -
    // MARK: Private
    
    private func handle(events: TableEvents) {
        switch events {
        case .didSelect(row: let result):
            self.statesHandler.onNext(.clickOn(indexRow: result.row))
            
            result.completion()
        case .handleCellEvents(at: let index, events: let events):
            if let events = events as? PokemonListCellEvents {
                switch events {
                case .image(let size, let completion):
                    self.statesHandler.onNext(.image(rows: [index], imageSize: size, { image in
                        completion(image)
                    }))
                }
            }
        case .didEndDisplaying(row: let row):
            self.statesHandler.onNext(.cellEndDisplaying(row: row))
        case .loadNextPage:
            self.statesHandler.onNext(.loadNextPage)
        }
    }
}



