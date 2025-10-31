//
//  GameViewController.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/29/25.
//

import UIKit

/// A view controller that represents the main controls for the slot machine game.
class GameViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    // MARK: Properties
    
    /// The main slot game engine for this app.
    private var gameEngine = GameEngine()
    
    /// The slot symbol images in a array of `UIImages`.
    private var slotSymbolImages = Symbol.allCases.compactMap { UIImage(named: $0.image) }

    // MARK: UI Components
    
    /// A UIView the shows the title for bet and total amount for the bet.
    private lazy var betAmountView = ChangeBetView()
    
    /// A UIView the shows the title for win amount and win total.
    private lazy var winAmountView = makeCreditView(title: "Win", amount: "\(gameEngine.slotMachine.winTotal)")
    
    /// A UIView the shows the title  for credit amount and credit total.
    private lazy var creditAmountView = makeCreditView(title: "Credit", amount: "\(gameEngine.slotMachine.creditTotal)")

    /// The background image that appears behind the slot reels.
    private var backgroundImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "reels-background")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    /// The play button to start a new slot game round.
    private var playGameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// A picker view to make to look like a slot reel.
    private var slotReelPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isUserInteractionEnabled = false
        return picker
    }()
    
    /// Makes a information credit view for the game.
    /// - Parameters:
    ///   - title: The title of the information.
    ///   - amount: The amount for the information
    /// - Returns: `GameCreditView` with the information added.
    private func makeCreditView(title: String, amount: String) -> GameCreditView {
       let view = GameCreditView()
       view.setCreditLabelText(title)
       view.setCreditAmountLabelText(amount)
       return view
   }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonActions()
        setupDelegates()
    }
    
    /// Present the `AddGameCreditViewController`.
    func showAddCreditsVC() {
        let gameCreditVC = AddGameCreditViewController()
        gameCreditVC.delegate = self
        gameCreditVC.isModalInPresentation = true
        present(gameCreditVC, animated: true, completion: nil)
    }
    
    /// Present the `PopUpViewController`.
    func showPopUpVC(symbol: Symbol) {
        let popUpVC = WinnerPopUpViewController(symbol: symbol)
        present(popUpVC, animated: true, completion: nil)
    }
    
    func showMessagePopUpVC(title: String) {
        let popUpVC = MessagePopUpViewController(title: title)
        present(popUpVC, animated: true, completion: nil)
    }

    // MARK: Setup
    
    /// Assigned the delegates for this view controller.
    func setupDelegates() {
        slotReelPickerView.delegate = self
        slotReelPickerView.dataSource = self
        betAmountView.delegate = self
    }

    /// Configures the button actions for the UI components.
    func setupButtonActions() {
        playGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }

    /// Configures the main layout for the game view.
    func setupUI() {

        // Add and configure the background image to fill the screen.
        view.insertSubview(backgroundImage, at: 0)
        view.addSubview(playGameButton)
        view.addSubview(slotReelPickerView)
        
        // Add a stack view the holds the bet, win and credit amount.
        let stackView = UIStackView(arrangedSubviews: [betAmountView, winAmountView, creditAmountView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // Background image.
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            playGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            playGameButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.20),
            playGameButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            stackView.bottomAnchor.constraint(equalTo: playGameButton.topAnchor, constant: -12),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.125),
            
            slotReelPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            slotReelPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            slotReelPickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            slotReelPickerView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -12)
        ])
    }

    // MARK: Actions

    /// Starts a new slot game whenever the play button is tapped.
    @objc func startGame() {
        guard gameEngine.startGame() else {
            handleGameStartFailure()
            return
        }
        
        playGameButton.isEnabled = false
        performSlotSpins()
    }
    
    /// Handles if the user can not start a game.
    func handleGameStartFailure() {
        if gameEngine.slotMachine.creditTotal == 0 {
            showAddCreditsVC()
        } else {
            showMessagePopUpVC(title: "Not enough credits!")
        }
    }
    
    /// Start performing the animation for slot spinning and updating the UI.
    func performSlotSpins() {
        gameEngine.playSound(sound: "spin")
        let (results, wonRound) = gameEngine.performSpin()
        var delay: TimeInterval = 0
        
        for index in 0..<slotReelPickerView.numberOfComponents {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {  [weak self] in
                if let row = Symbol.allCases.firstIndex(of: results[index]) {
                    self?.slotReelPickerView.selectRow(row, inComponent: index, animated: true)
                }
            }
            
            delay += 0.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            if wonRound {
                if let winnerSymbol = results.first {
                    self?.showPopUpVC(symbol: winnerSymbol)
                    self?.gameEngine.playSound(sound: "win")
                }
            }
            self?.updateCreditsUI()
            self?.playGameButton.isEnabled = true
            
            if self?.gameEngine.slotMachine.creditTotal == 0 {
                self?.showAddCreditsVC()
            }
        }
    }
    
    /// Update the win and credit totals UI.
    func updateCreditsUI() {
        let slotMachine = gameEngine.slotMachine
        winAmountView.setCreditAmountLabelText("\(slotMachine.winTotal)")
        creditAmountView.setCreditAmountLabelText("\(slotMachine.creditTotal)")
    }
}

// MARK: Delegates

extension GameViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return slotSymbolImages.count * 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        
        let index = row % slotSymbolImages.count
        return UIImageView(image: slotSymbolImages[index])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return slotSymbolImages[component].size.height + 1
    }
}

extension GameViewController: AddGameCreditViewControllerDelegate {
    func didUpdateCreditAmount(amount: Int) {
        gameEngine.addCredits(amount: amount)
        creditAmountView.setCreditAmountLabelText("\(gameEngine.slotMachine.creditTotal)")
    }
}

extension GameViewController: ChangeBetViewDelegate {
    func updateBetAmount(amount: Int) {
        gameEngine.setBetAmount(amount: amount)
    }
}
