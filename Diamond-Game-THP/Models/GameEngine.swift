//
//  GameEngine.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/30/25.
//
import AVFoundation

/// The main game engine use to interact with the `SlotMachine`.
final class GameEngine {
    
    /// Create a slot machine.
    private(set) var slotMachine = SlotMachine()
    
    /// The audio player.
    private var player : AVAudioPlayer?
    
    /// Checks to see if credit total is greate than zero and if the bet amount is less than available credits.
    /// - Returns: Boolean values if user can start game.
    func startGame() -> Bool {
        guard slotMachine.creditTotal > 0 else { return false }
        guard slotMachine.canSpin else { return false }
        return true
    }
    
    /// Spins the slot machine and generates a random result for three different
    /// symbols. Evalutes the results in the slot machine to see if won.
    /// - Returns: A tuple with the results of the spin.
    func performSpin() -> ([Symbol], Bool) {
        var result = [Symbol]()
        for _ in 0..<3 {
            if let symbol = Symbol.allCases.randomElement() {
                result.append(symbol)
            }
        }
        let won = slotMachine.evaluateSpin(result)
        return (result, won)
    }
    
    /// Add credits to the slot machine.
    /// - Parameter amount: The amount to add.
    func addCredits(amount: Int) {
        slotMachine.addCredits(amount)
    }
    
    /// Sets the bet amount for the round.
    /// - Parameter amount: Amount to bet.
    func setBetAmount(amount: Int) {
        slotMachine.setBetAmount(amount: amount)
    }
    
    /// Plays a sound in from the player in `AVFoundation. `
    /// - Parameter name: The audio file name.
    func playSound(sound name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else{
            return
        }
        
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}
