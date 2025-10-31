//
//  GameShowChangeBetView.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/30/25.
//

import UIKit

/// The delegate protocol for `ChangeBetView`.
protocol ChangeBetViewDelegate: AnyObject {
    func updateBetAmount(amount: Int)
}

/// A view that displays the a segmented controller to change the bet amount.
class ChangeBetView: UIView {
    
    /// The bet amounts number values.
    private var betAmounts = [1, 5, 10]
    
    /// Delegate for bet amount changes.
    weak var delegate: ChangeBetViewDelegate?

    // MARK: UI Components
    
    /// The title label.
    private lazy var betTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "BET"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemYellow
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowRadius = 8.0
        label.layer.masksToBounds = false
        return label
    }()
    
    /// The segement control to be able to select the differnt bet amounts.
    private lazy var betSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["$1", "$5", "$10"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 48, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.systemYellow
        ]
        segmentedControl.selectedSegmentTintColor = UIColor.black.withAlphaComponent(0.7)
        segmentedControl.setTitleTextAttributes(attributes, for: .normal)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChange), for: .valueChanged)
        return segmentedControl
    }()
    
    // MARK: - Initializers
    
    /// Initializes the view programmatically.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    /// Required initializer for storyboard/XIB usage (not supported here).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(betTitleLabel)
        addSubview(betSegmentedControl)

        NSLayoutConstraint.activate([
            betTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            betTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            betTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            betSegmentedControl.topAnchor.constraint(equalTo: betTitleLabel.bottomAnchor, constant: 8),
            betSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            betSegmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            betSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        ])
    }
    
    // MARK: - Actions
    
    /// Update the bet amount for delegate. 
    @objc func segmentedControlValueChange(_ sender: UISegmentedControl) {
        let betAmount = betAmounts[sender.selectedSegmentIndex]
        delegate?.updateBetAmount(amount: betAmount)
    }
}
