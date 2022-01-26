//
//  DetailPokemonVC.swift
//  pokemon_table
//
//  Created by mac on 21.01.2022.
//

import UIKit
import RxSwift
import RxCocoa

enum DetailPokemonVCError: Error {
    case error(String)
}

class DetailPokemonVC: UIViewController, RootViewGettable {
    
    // MARK: -
    // MARK: Typealias
    
    typealias View = DetailPokemonView
    
    // MARK: -
    // MARK: Variables
    
    private var api: PokemonAPI
    private var pokemon: Pokemon
    private var abilities: [PokemonAbility]?
    private var disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: Initialization
    
    public init(api: PokemonAPI, pokemon: Pokemon) {
        self.pokemon = pokemon
        self.api = api
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Private
    
    private func prepareObserving() {
        self.rootView?.statesHandler.bind { [weak self] states in
            switch states {
            case .abilityButtonClick(label: let label, index: let index):
                let insertIndex = index + 1
                let arrangedSubviews = self?.rootView?.stackView?.arrangedSubviews
                
                if arrangedSubviews?.count == insertIndex
                    || arrangedSubviews?[insertIndex] as? UIButton != nil
                {
                   guard let ability = self?.abilities?.first(where: { $0.name ==  label })
                    else {
                        self?.showAlert(with: DetailPokemonVCError.error("Ablity doesnt exist"))
                        return
                    }
                     
                    self?.insertToViewEntry(of: ability, at: insertIndex)

                } else {
                    self?.rootView?.toggleView(at: insertIndex)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func switchedResult<T>(of result: F.PokemonResult<T>, success: (T) -> ()) {
        switch result {
        case .success(let features):
            success(features)
        case .failure(let error):
            self.showAlert(with: error)
        }
    }
    
    private func setImageToView() {
        self.api.images(pokemon: self.pokemon, imageType: .frontDefault) { [weak self] result in
            self?.switchedResult(of: result) { image in
                self?.rootView?.imageView?.image = UIImage(data: image)
            }
        }
    }
    
    private func setAbilitiesToView(completion: @escaping ([PokemonAbility]) -> ()) {
        self.api.features(pokemon: self.pokemon) { [weak self] result in
            self?.switchedResult(of: result, success: { features in
                let abilities = features.abilities
                
                abilities.forEach {
                    let button = UIButton(type: .system)
                    
                    button.setTitle($0.name, for: .normal)
                    button.titleLabel?.font = button.titleLabel?.font.withSize(19)
                    
                    self?.rootView?.display(button: button)
                }
                
                completion(abilities)
            })
        }
    }
    
    private func insertToViewEntry(of ability: PokemonAbility, at stackIndex: Int) {
        self.api.effect(of: ability, completion: { [weak self] in
            self?.switchedResult(of: $0, success: {
                if let effectEntry = $0.entry {
                    let label = UILabel()
                    
                    label.text = effectEntry
                    label.numberOfLines = 0
                    //label.isHidden = true
                    
                    self?.rootView?.stackView?.insertArrangedSubview(label, at: stackIndex)
                } else {
                    self?.showAlert(with: DetailPokemonVCError.error("Error effect entry"))
                }
            })
        })
    }
    
    // MARK: -
    // MARK: Overriden

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView?.name?.text = self.pokemon.name
        
        self.setImageToView()
        self.setAbilitiesToView { self.abilities = $0 }
        
        self.prepareObserving()
    }
}

