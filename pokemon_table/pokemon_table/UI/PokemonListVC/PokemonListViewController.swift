//
//  PokemonListViewController.swift
//  pokemon_table
//
//  Created by mac on 12.01.2022.
//

import UIKit
import RxSwift
import RxCocoa

public enum PokemonListControllerStates {
    
    case detail(pokemon: Pokemon)
}

class PokemonListViewController: BaseViewController<PokemonListView> {

    // MARK: -
    // MARK: Variables
    
    private var pokemons: [Pokemon] = []
    
    private var nextPage: URL?
    
    private var cancelablePokemonImageTasks: [UUID: Task] = [:]
    
    public var events: Observable<PokemonListControllerStates> {
        self.eventsEmitter.asObserver()
    }
    private let eventsEmitter = PublishSubject<PokemonListControllerStates>()
    
    private let api: PokemonAPI
    private let cellImageType = PokemonImageTypes.frontDefault
    
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
    // MARK: ViewLifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.loadPokemons()
    }

    
    // MARK: -
    // MARK: Public
    
    public func loadPokemons() {
        self.api.pokemons(page: 1) { result in
            self.switchResult(result: result) { node in
                self.pokemons.append(contentsOf: node.results)
                self.nextPage = node.next

                self.rootView?.update(pokemons: node.results)
            }
        }
    }
    
    // MARK: -
    // MARK: Overriden
    
    public override func prepareObserving(disposeBag: DisposeBag) {
        self.rootView?.statesHandler.bind { [weak self] states in
            switch states {
            case .pokemons(let completion):
                completion(self?.pokemons ?? [])
                
            case .image(rows: let rows, let imageSize, let completion):
                self?.imageBind(rows: rows, imageSize: imageSize, completion: completion)

            case .clickOn(indexRow: let indexRow):
                if let pokemon =  self?.pokemons[indexRow] {
                    self?.eventsEmitter.onNext(.detail(pokemon: pokemon))
                }
            case .cellEndDisplaying(row: let row):
                guard let pokemon = self?.pokemons[row] else {
                    return
                }
                
                self?.cancelablePokemonImageTasks[pokemon.id]?.cancel()
            case .loadNextPage:
                self?.loadNextPage()
            }
        }.disposed(by: disposeBag)
    }
        
    // MARK: -
    // MARK: Private
    
    private func imageBind(rows: [Int], imageSize: CGSize, completion: ((UIImage) -> ())?) {
        rows.forEach { index in
            let pokemon = self.pokemons[index]
            
            self.api.features(of: pokemon) { [weak self] result in
                self?.switchResult(result: result, unwrappedValue: { features in
                    let task = self?.api.image(
                        features: features,
                        imageType: .frontDefault,
                        size: imageSize
                    ) { result in
                        self?.switchResult(result: result) { completion?($0) }
                    }
                    
                    self?.cancelablePokemonImageTasks[pokemon.id] = task
                })
            }
        }
    }
    
    private func loadNextPage() {
        if let page = nextPage {
            self.api.pokemons(url: page) { [weak self] result in
                self?.switchResult(result: result) { node in
                    let pokemons = node.results
                    
                    self?.pokemons.append(contentsOf: pokemons)
                    self?.nextPage = node.next
                    
                    self?.rootView?.update(pokemons: pokemons)
                }
            }
        }
    }
    
}

