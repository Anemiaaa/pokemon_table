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

class DetailPokemonView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    @IBOutlet public weak var stackView: UIStackView?
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var name: UILabel?
    
    public var statesHandler = PublishSubject<States>()
    
    // MARK: -
    // MARK: Public
    
    public func display(button: UIButton) {
        button.addTarget(
            self,
            action: #selector(onAbilityButtonClick(sender:)),
            for: .touchUpInside
        )
        
        self.stackView?.addArrangedSubview(button)
    }
    
    public func toggleView(at index: Int, animated: Bool = true) {
        guard let view = self.stackView?.arrangedSubviews[index] else {
            return
        }
        //let endProperty = view.alpha == 0.0 ? 1.0: 0.0
        let endProperty = view.isHidden == true ? false : true
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                //view.alpha = endProperty
                view.isHidden = endProperty
            }
        } else {
            //view.alpha = endProperty
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
