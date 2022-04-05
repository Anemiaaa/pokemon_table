//
//  DetaiPokemonView.swift
//  pokemon_table
//
//  Created by mac on 24.01.2022.
//

import UIKit
import RxSwift

public enum States {
    
    case abilityButtonClick(label: String, index: Int)
}

class DetailPokemonView: BaseView {
    
    // MARK: -
    // MARK: Variables
    
    @IBOutlet public weak var stackView: UIStackView?
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var name: UILabel?
    
    public var statesHandler = PublishSubject<States>()
    
    // MARK: -
    // MARK: Public
    
    public func displayButton(label: String, fontSize: CGFloat) {
        let button = UIButton(type: .system)
        
        button.setTitle(label, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(fontSize)
        
        button.addTarget(
            self,
            action: #selector(onAbilityButtonClick(sender:)),
            for: .touchUpInside
        )
        
        self.stackView?.addArrangedSubview(button)
    }
    
    public func insertLabel(at stackIndex: Int, text: String, rows: Int) {
        let label = UILabel()
        
        label.text = text
        label.numberOfLines = rows

        self.insertArrangedSubview(view: label, at: stackIndex)
    }
    
    public func insertArrangedSubview(view: UIView, at stackIndex: Int) {
        view.isHidden = true
        self.stackView?.insertArrangedSubview(view, at: stackIndex)
        
        UIView.animate(withDuration: 0.5) {
            view.isHidden = false
        }
    }
    
    public func toggleView(at index: Int, animated: Bool = true) {
        guard let view = self.stackView?.arrangedSubviews[index] else {
            return
        }
        let endProperty = !view.isHidden
        
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            view.isHidden = endProperty
        }
    }
    
    // MARK: -
    // MARK: Private
    
    @objc private func onAbilityButtonClick(sender: UIButton) {
        guard let index = self.stackView?
                .arrangedSubviews
                .firstIndex(where: { $0 == sender }),
              let title = sender.titleLabel?.text
        else { return }
        
        self.statesHandler.onNext(.abilityButtonClick(label: title, index: index))
    }
    
}
