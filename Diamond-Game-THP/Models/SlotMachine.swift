//
//  SlotMachine.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/29/25.
//

/// Represent the logic and state of a slot machine.
struct SlotMachine {
    
    /// The bet amount for a round.
    private(set) var betAmount = 1
    
    /// Total number of winnings for the game.
    private(set) var winTotal = 0
    
    /// Credit available. The intitial value is "100".
    private(set) var creditTotal = 100
    
    /// Whether the user has enough credits to spin.
    var canSpin: Bool {
        betAmount <= creditTotal
    }
    
    /// Evaluates a spin forr a round.
    /// - Parameter results: An array of three random symbols.
    /// - Returns: True if the round is won, false otherwise.
    mutating func evaluateSpin(_ results: [Symbol]) -> Bool {
        creditTotal -= betAmount

        // Make the results a Set and if there is one value that
        // means the round was won.
        if Set(results).count == 1, let firstSymbol = results.first {
            winTotal += betAmount * firstSymbol.multiplier
            return true
        }

        return false
    }
    
    /// Subtract the credits available from the bet amount.
    mutating func subtractCreditAmountFromBet() {
        creditTotal -= betAmount
    }
    
    /// Add credits to the credits available.
    mutating func addCredits(_ amount: Int) {
        creditTotal += amount
    }
    
    /// Remove credits to the credits available.
    mutating func removeCredits(_ amount: Int) {
        creditTotal -= amount
    }
    
    /// Set bet amount.
    mutating func setBetAmount(amount: Int) {
        betAmount = amount
    }
}
