//
//  PokemonListViewController.swift
//  pokemon_table
//
//  Created by mac on 12.01.2022.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonListViewController: UIViewController, RootViewGettable, PresentableViewController {

    // MARK: -
    // MARK: Typealias
    
    typealias Cell = PokemonListTableCell
    typealias View = PokemonListView
    
    // MARK: -
    // MARK: Variables
    
    public var delegate: NavigateViewControllerDelegate?
    
    private let api: PokemonAPI
    private var pokemons: [Pokemon] = []
    private let disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: Initialization
    
    public init(api: PokemonAPI) {
        self.api = api
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Public
    
    public func addPokemons(count: Int, completion: F.PokemonCompletion<[Pokemon], PokemonApiError>?) {
        self.api.pokemons(count: count) { result in
            switch result {
            case .success(let node):
                self.pokemons = node.results
                
                completion?(.success(node.results))
                
                self.rootView?.tableView?.reloadData()
            case .failure(let error):
                self.showAlert(title: "Network Error", error: error)
            }
        }
    }
    
    // MARK: -
    // MARK: Private
    
    private func prepareObserving() {
        self.rootView?.statesHandler.bind { [weak self] states in
            switch states {
            case .pokemons(let completion):
                completion(self?.pokemons ?? [])
                
            case .image(pokemon: let pokemon, imageType: let imageType, let completion):
                self?.api.image(pokemon: pokemon, imageType: imageType) { [weak self] result in
                    switch result {
                    case .success(let image):
                         completion(image)
                    case .failure(let error):
                        self?.showAlert(title: "Network Error", error: error)
                    }
                }
            case .clickOn(indexRow: let indexRow):
                self?.delegate?.navigateToNextPage(self?.pokemons[indexRow])
            }
        }.disposed(by: self.disposeBag)
    }
        
    // MARK: -
    // MARK: Overriden
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.addPokemons(count: 50, completion: nil)
        
        self.prepareObserving()
    }

}

