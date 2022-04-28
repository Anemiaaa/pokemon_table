//
//  DetailPokemonViewController.swift
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

class DetailPokemonViewController: BaseViewController<DetailPokemonView> {
    
    // MARK: -
    // MARK: Variables
    
    private var api: PokemonAPI
    private var pokemon: Pokemon
    private var abilities: [PokemonAbility]?
    
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
    // MARK: ViewLifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView?.name?.text = self.pokemon.name
        
        self.setImageToView()
        self.setAbilitiesToView { self.abilities = $0 }
    }
    
    // MARK: -
    // MARK: Overriden
    
    public override func prepareObserving(disposeBag: DisposeBag) {
        self.rootView?.statesHandler.bind { [weak self] states in
            switch states {
            case .abilityButtonClick(label: let label, index: let index):
                self?.abilityButtonClickHandler(label: label, index: index)
            }
        }.disposed(by: disposeBag)
    }
    
    // MARK: -
    // MARK: Private
    
    private func abilityButtonClickHandler(label: String, index: Int) {
        let insertIndex = index + 1
        let arrangedSubviews = self.rootView?.stackView?.arrangedSubviews
        
        if arrangedSubviews?.count == insertIndex
            || arrangedSubviews?[insertIndex] as? UIButton != nil
        {
           guard let ability = self.abilities?.first(where: { $0.name ==  label })
            else {
                self.showAlert(title: "Error", message: "Ability doesnt exist")
                return
            }
             
            self.insertToViewEntry(of: ability, at: insertIndex)

        } else {
            self.rootView?.toggleView(at: insertIndex)
        }
    }
    
    private func setImageToView() {
        guard let imageSize = self.rootView?.imageView?.frame.size else {
            self.showAlert(title: "Image error", message: nil)
            return
        }
        self.api.features(pokemon: pokemon) { result in
            switch result {
            case .success(let features):
                self.api.image(features: features, imageType: .frontDefault, size: imageSize) { [weak self] result in
                    self?.switchResult(result: result) {
                        self?.rootView?.imageView?.image = $0
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Network Error", error: error)
            }
        }
    }
    
    private func setAbilitiesToView(completion: @escaping ([PokemonAbility]) -> ()) {
        self.api.features(pokemon: self.pokemon) { [weak self] result in
            self?.switchResult(result: result) { features in
                let abilities = features.abilities
                
                abilities.forEach {
                    self?.rootView?.displayButton(label: $0.name, fontSize: 19)
                }
                
                completion(abilities)
            }
        }
    }
    
    private func insertToViewEntry(of ability: PokemonAbility, at stackIndex: Int) {
        self.api.effect(of: ability, completion: { [weak self] in
            self?.switchResult(result: $0) {
                if let effectEntry = $0.entry {
                    self?.rootView?.insertLabel(at: stackIndex, text: effectEntry, rows: 0)
                } else {
                    self?.showAlert(title: "Error", message: "Couldnt find ability entry")
                }
            }
        })
    }
}


