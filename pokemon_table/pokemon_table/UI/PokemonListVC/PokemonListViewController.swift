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
    
    private var pokemons: [Pokemon] = []
    private var prefetchedTasks: Cacher<NSIndexPath, URLSessionDataTask>
    private var prefetchedImages: Cacher<NSIndexPath, UIImage>
    
    private let api: PokemonAPI
    private let disposeBag = DisposeBag()
    private let serialQueue = DispatchQueue(label: "Prefetch queue")
    private let cellImageType = PokemonImageTypes.frontDefault
    
    // MARK: -
    // MARK: Initialization
    
    public init(api: PokemonAPI) {
        self.api = api
        
        self.prefetchedTasks = Cacher(config: ConfigCacher.default)
        self.prefetchedImages = Cacher(config: ConfigCacher.default)
        
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
                
            case .image(indexPath: let indexPath, let imageSize, let completion):
                self?.imageBind(indexPath: indexPath, imageSize: imageSize, completion: completion)

            case .prefetch(indexPaths: let indexPaths, imageSize: let size):
                self?.prefetch(indexPaths: indexPaths, imageSize: size)
                
            case .stopLoadAt(indexPaths: let indexPaths):
                indexPaths.forEach { [weak self] index in
                    if let task = self?.prefetchedTasks.cachedData(for: index as NSIndexPath) {
                        self?.api.cancel(task: task)
                        
                        self?.prefetchedTasks.remove(for: index as NSIndexPath)
                    }
                }

            case .clickOn(indexRow: let indexRow):
                self?.delegate?.navigateToNextPage(self?.pokemons[indexRow])
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
    
    private func prefetch(indexPaths: [IndexPath], imageSize: CGSize) {
        indexPaths.forEach { [weak self] index in
            self?.serialQueue.async {
                guard let pokemon = self?.pokemons[index.row] else {
                    self?.showAlert(title: "Error", message: "Cannot prefetch data")
                    return
                }
                self?.api.features(pokemon: pokemon, completion: { result in
                    switch result {
                    case .success(let features):
                        if let task = self?.api.image(
                         features: features,
                         imageType: self?.cellImageType ?? .frontDefault,
                         size: imageSize,
                         completion: { [weak self] result in
                             self?.prefetchedImages.insert(
                                 value: self?.switchResult(result: result) ?? UIImage(),
                                 for: index as NSIndexPath
                             )
                         })
                        {
                            self?.prefetchedTasks.insert(value: task, for: index as NSIndexPath)
                        }
                    case .failure(let error):
                        self?.showAlert(title: "Network Error", error: error)
                    }
                })
            }
        }
    }
    
    private func imageBind(indexPath: IndexPath, imageSize: CGSize, completion: @escaping (UIImage) -> ()) {
        let pokemon = self.pokemons[indexPath.row]

        if let image = self.prefetchedImages.cachedData(for: indexPath as NSIndexPath) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            self.api.features(pokemon: pokemon, completion: { [weak self] result in
                switch result {
                case .success(let features):
                    self?.api.image(
                        features: features,
                        imageType: self?.cellImageType ?? .frontDefault,
                        size: imageSize
                    ) {
                        completion(self?.switchResult(result: $0) ?? UIImage())
                    }
                case .failure(let error):
                    self?.showAlert(title: "Network Error", error: error)
                }
            })
        }
    }
    
    // MARK: -
    // MARK: Overriden
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.addPokemons(count: 50, completion: nil)
        
        self.prepareObserving()
    }

}

