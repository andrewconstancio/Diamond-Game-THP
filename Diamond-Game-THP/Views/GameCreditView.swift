//
//  GameCreditView.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/29/25.
//

import UIKit

/// A view where you can set the title and amount label to show game credit information.
class GameCreditView: UIView {
    
    // MARK: UI Components
    
    /// The title label (ex: "CREDITS").
    private var titleLabel: UILabel = {
        let label = UILabel()
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
    
    /// The amount label (ex: "$100").
    private var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemYellow.withAlphaComponent(0.9)
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowRadius = 8.0
        return label
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
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, amountLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public Methods
    
    /// Sets the title text (e.g., "CREDITS").
    func setCreditLabelText(_ text: String) {
        titleLabel.text = text.uppercased()
    }
    
    /// Sets the credit amount text (e.g., "$100").
    func setCreditAmountLabelText(_ text: String) {
        amountLabel.text = "$" + text
    }
}
