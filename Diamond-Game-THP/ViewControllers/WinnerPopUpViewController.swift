//
//  PopupViewController.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/30/25.
//

import UIKit


/// A view controller pop up view whenever a user wins a round.
class WinnerPopUpViewController: UIViewController {
    
    // MARK: UI Components
    
    /// The main "you won" title.
    private lazy var messageTitle: UILabel = {
        let label = UILabel()
        label.text = "YOU WON!!! 🎉"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemYellow
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowRadius = 8.0
        label.layer.masksToBounds = false
        return label
    }()
    
    /// Slot symbol to show so the user know which multipler.
    private lazy var symbolImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    /// Label to show the payout multipler.
    private lazy var payoutAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowRadius = 8.0
        label.layer.masksToBounds = false
        return label
    }()
    
    /// Button so the user can dismiss the pop up view controller.
    private var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.backgroundColor = .brightRed
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.layer.borderWidth = 4.0
        return button
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animiateView()
    }
    
    /// This animate makes the whole view shake when it appears.
    func animiateView() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 30, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 30, y: view.center.y))

        view.layer.add(animation, forKey: "position")
    }
    
    /// Initalizer for this view controller.
    /// - Parameter title: The title of the main message.
    init(symbol: Symbol) {
        super.init(nibName: nil, bundle: nil)
        symbolImage.image = UIImage(named: symbol.image)
        payoutAmountLabel.text = "x\(symbol.multiplier)"
    }
    
    /// Required initializer for storyboard/XIB usage (not supported here).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setupUI() {
        
        // Setup the view controllers view style.
        preferredContentSize = CGSize(width: 500, height: 550)
        view.backgroundColor = UIColor.primaryBackground
        view.layer.borderColor = UIColor.systemYellow.cgColor
        view.layer.borderWidth = 4.0
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        
        view.addSubview(messageTitle)
        view.addSubview(dismissButton)
        view.addSubview(symbolImage)
        view.addSubview(payoutAmountLabel)
        
        NSLayoutConstraint.activate([
            messageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            messageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            symbolImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            symbolImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            symbolImage.heightAnchor.constraint(equalToConstant: 150),
            symbolImage.widthAnchor.constraint(equalToConstant: 200),
            
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 75),
            dismissButton.widthAnchor.constraint(equalToConstant: 300),
            
            payoutAmountLabel.topAnchor.constraint(equalTo: symbolImage.bottomAnchor, constant: 4),
            payoutAmountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payoutAmountLabel.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: 8)
        ])
    }
    
    // MARK: Actions
    
    func setupActions() {
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
