//
//  MessagePopUpViewController.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/30/25.
//
import UIKit

/// A view controller that that looks like a pop up and can pass a message into. 
class MessagePopUpViewController: UIViewController {
    
    // MARK: UI Components
    
    /// The main title.
    private lazy var messageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemYellow
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowRadius = 8.0
        label.layer.masksToBounds = false
        return label
    }()
    
    /// Button so the user can dismiss the pop up view controller
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
    
    /// Initalizer for this view controller.
    /// - Parameter title: The title of the main message.
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        messageTitle.text = title
    }
    
    /// Required initializer for storyboard/XIB usage (not supported here).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setupUI() {
        
        preferredContentSize = CGSize(width: 500, height: 300)
        view.backgroundColor = UIColor.primaryBackground
        view.layer.borderColor = UIColor.systemYellow.cgColor
        view.layer.borderWidth = 4.0
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        
        
        view.addSubview(messageTitle)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            messageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            messageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 75),
            dismissButton.widthAnchor.constraint(equalToConstant: 250),
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
