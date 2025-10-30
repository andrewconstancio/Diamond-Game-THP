//
//  GameViewController.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/29/25.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: Variables
    
    /// The slot images used in the picker view to represent a slot machine.
    private let images = [
        UIImage(named: "slot-bell"),
        UIImage(named: "slot-cherries"),
        UIImage(named: "slot-diamond"),
        UIImage(named: "slot-lemon"),
        UIImage(named: "slot-seven"),
        UIImage(named: "slot-star")
    ]

    // MARK: UI Components
    
    /// A UIView the shows the title title for bet and total amount for the bet.
    private var betAmountView = GameCreditView()
    
    /// A UIView the shows the title title for win amount and win total.
    private var winAmountView = GameCreditView()
    
    /// A UIView the shows the title title for credit amount and credit total.
    private var creditAmountView = GameCreditView()

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
        return picker
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonActions()
        
        slotReelPickerView.delegate = self
        slotReelPickerView.dataSource = self
        
        betAmountView.setCreditLabelText("Bet")
        betAmountView.setCreditAmountLabelText("100")
        
        winAmountView.setCreditLabelText("Win")
        winAmountView.setCreditAmountLabelText("0")
        
        creditAmountView.setCreditLabelText("Credit")
        creditAmountView.setCreditAmountLabelText("500")
    }

    // MARK: Setup

    /// Congfigures the button actions for the UI components.
    func setupButtonActions() {
        playGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }

    /// Configures the main layout for the game view.
    func setupUI() {

        // Add and configure the background image to fill the screen.
        view.insertSubview(backgroundImage, at: 0)

        NSLayoutConstraint.activate([
             backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
             backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Play game button.
        view.addSubview(playGameButton)

        NSLayoutConstraint.activate([
            playGameButton.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
            playGameButton.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -35),
            playGameButton.widthAnchor.constraint(equalToConstant: 200),
            playGameButton.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        // Add and configure the reel picker view to stretch across the background.
        view.addSubview(slotReelPickerView)
        
        NSLayoutConstraint.activate([
            slotReelPickerView.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 40),
            slotReelPickerView.topAnchor.constraint(equalTo: backgroundImage.topAnchor),
            slotReelPickerView.bottomAnchor.constraint(equalTo: playGameButton.topAnchor),
            slotReelPickerView.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -40)
        ])
        
        // Add and configure a stack view the holds the bet, win and credit amount.
        let stackView = UIStackView(arrangedSubviews: [betAmountView, winAmountView, creditAmountView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 80),
            stackView.bottomAnchor.constraint(equalTo: playGameButton.topAnchor, constant: -12),
            stackView.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -80),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    // MARK: Actions

    /// Starts a new slot game whenever the play button is tapped.
    @objc func startGame() {
        backgroundImage.isUserInteractionEnabled = false
        animateSlotsRolling()
    }
    
    /// Animating spinning the slot reels.
    func animateSlotsRolling() {
        var delay: TimeInterval = 0
        let repetitions = 6
        
        for index in 0..<slotReelPickerView.numberOfComponents {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                let totalRows = repetitions * self.images.count
                let randomRow = Int.random(in: self.images.count..<totalRows)
                self.slotReelPickerView.selectRow(randomRow, inComponent: index, animated: true)
            })
            
            delay += 0.3
        }
    }
}

extension GameViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count * 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        
        let index = row % images.count
        return UIImageView(image: images[index])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        guard let height = images[component]?.size.height else { return 100 }
        return height + 1
    }
}
