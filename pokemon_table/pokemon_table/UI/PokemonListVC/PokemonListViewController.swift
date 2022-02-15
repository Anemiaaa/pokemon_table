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

class PokemonListViewController: BaseViewController<PokemonListViewController>, RootViewGettable {

    // MARK: -
    // MARK: Typealias
    
    typealias View = PokemonListView
    
    // MARK: -
    // MARK: Variables
    
    public let coordinator = PublishSubject<PokemonListControllerStates>()
    
    private var pokemons: [Pokemon] = []
    private var prefetchedImages: Cacher<NSIndexPath, UIImage>
    
    private let api: PokemonAPI
    private let disposeBag = DisposeBag()
    private let cellImageType = PokemonImageTypes.frontDefault
    
    // MARK: -
    // MARK: Initialization
    
    public init(api: PokemonAPI) {
        self.api = api
        
        self.prefetchedImages = Cacher(config: ConfigCacher.default)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: ViewLifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.addPokemons(count: 50, completion: nil)
        
        self.prepareObserving()
    }

    
    // MARK: -
    // MARK: Public
    
    public func addPokemons(count: Int, completion: F.PokemonCompletion<[Pokemon], PokemonApiError>?) {
        self.api.pokemons(count: count) { result in
            switch result {
            case .success(let node):
                self.pokemons = node.results
                
                completion?(.success(node.results))
                
                self.rootView?.update()
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
                
            case .image(indexPaths: let indexPaths, let imageSize, let completion):
                self?.imageBind(indexPaths: indexPaths, imageSize: imageSize, completion: completion)

            case .clickOn(indexRow: let indexRow):
                if let pokemon =  self?.pokemons[indexRow] {
                    self?.coordinator.onNext(.detail(pokemon: pokemon))
                }
            }
        }.disposed(by: self.disposeBag)
    }
        
    // MARK: -
    // MARK: Private
    
    private func switchResult<T, Error>(result: Result<T, Error>) -> T? {
        switch result {
        case .success(let value):
             return value
        case .failure(let error):
            self.showAlert(title: "Error", error: error)
            return nil
        }
    }
    
    private func imageBind(indexPaths: [IndexPath], imageSize: CGSize, completion: ((UIImage) -> ())?) {
        indexPaths.forEach { index in
            let pokemon = self.pokemons[index.row]

            DispatchQueue.global().async {
                if let image = self.prefetchedImages.cachedData(for: index as NSIndexPath) {
                    DispatchQueue.main.async {
                        completion?(image)
                    }
                } else {
                    self.api.features(pokemon: pokemon, completion: { [weak self] result in
                        guard let features = self?.switchResult(result: result) else {
                            return
                        }
                        
                        self?.api.image(
                            features: features,
                            imageType: self?.cellImageType ?? .frontDefault,
                            size: imageSize
                        ) { result in
                            let image = self?.switchResult(result: result) ?? UIImage()
                            
                            self?.prefetchedImages.insert(value: image, for: index as NSIndexPath)
                            
                            completion?(image)
                        }
                    })
                }
            }
        }
    }
    
    
    
}

