//
//  Symbol.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/30/25.
//

/// An enum that represents all slot symbols.
enum Symbol: CaseIterable {
    case cherry, lemon, seven, bell, star, diamond
    
    var image: String {
        switch self {
        case .cherry:
            return "slot-cherries"
        case .lemon:
            return "slot-lemon"
        case .seven:
            return "slot-seven"
        case .star:
            return "slot-star"
        case .bell:
            return "slot-bell"
        case .diamond:
            return "slot-diamond"
        }
    }
    
    var multiplier: Int {
        switch self {
        case .cherry:
            return 2
        case .lemon:
            return 3
        case .seven:
            return 5
        case .bell:
            return 10
        case .star:
            return 15
        case .diamond:
            return 25
        }
    }
}
