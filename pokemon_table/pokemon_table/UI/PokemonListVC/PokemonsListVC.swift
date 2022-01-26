//
//  PokemonsListVC.swift
//  pokemon_table
//
//  Created by mac on 12.01.2022.
//

import UIKit

class PokemonsListVC: UIViewController, PokemonCustomTableView {

    // MARK: -
    // MARK: Typealias
    
    typealias Cell = PokemonListTableCell
    
    // MARK: -
    // MARK: Variables
    
    @IBOutlet weak var tableView: UITableView?
    
    private let api: PokemonAPI
    private var pokemons: [Pokemon] = []

    
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
    
    public func addPokemons(count: Int, completion: F.PokemonCompletion<[Pokemon]>?) {
        self.api.pokemons(count: count) { result in
            switch result {
            case .success(let node):
                self.pokemons = node.results
                
                completion?(.success(node.results))
            case .failure(let error):
                self.showAlert(with: error)
                
                completion?(.failure(error))
            }
            self.tableView?.reloadData()
        }
    }
        
    // MARK: -
    // MARK: Overriden
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(cell: Cell.self)
        
        self.addPokemons(count: 50, completion: nil)
    }

}

extension PokemonsListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView?.dequeueReusableCell(withIdentifier: Cell.id(), for: indexPath) as? Cell {
            let pokemon = self.pokemons[indexPath.row]
            
            cell.name?.text = pokemon.name
            
            self.api.images(pokemon: pokemon, imageType: .frontDefault) { [weak self] result in
                switch result {
                case .success(let imageData):
                    cell.avatar?.image = UIImage(data: imageData)
                     
                case .failure(let error):
                    self?.showAlert(with: error)
                }
            }
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailPokemonVC(api: self.api, pokemon: self.pokemons[indexPath.row])
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
