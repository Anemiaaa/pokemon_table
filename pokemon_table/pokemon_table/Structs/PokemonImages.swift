//
//  PokemonImages.swift
//  pokemon_table
//
//  Created by mac on 20.01.2022.
//

import Foundation

public struct PokemonImages {
    
    public let backDefault: URL
    public let backFemale: URL?
    public let backShiny: URL
    public let backShinyFemale: URL?
    public let frontDefault: URL
    public let frontFemale: URL?
    public let frontShiny: URL
    public let frontShinyFemale: URL?
}

extension PokemonImages: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"

    }
}

public enum PokemonImageTypes {
    case backDefault
    case backFemale
    case backShiny
    case backShinyFemale
    case frontDefault
    case frontFemale
    case frontShiny
    case frontShinyFemale
}
