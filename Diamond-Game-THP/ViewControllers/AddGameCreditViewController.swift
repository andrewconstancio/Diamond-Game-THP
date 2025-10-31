//
//  GameCreditViewController.swift
//  Diamond-Game-THP
//
//  Created by Andrew Constancio on 10/29/25.
//

import UIKit

/// A delegate protocol for `AddGameCreditViewController`.
protocol AddGameCreditViewControllerDelegate: AnyObject {
    func didUpdateCreditAmount(amount: Int)
}

/// A view controller that looks like a pop up where users can add credits.
class AddGameCreditViewController: UIViewController {
    
    // MARK: Properties
    
    /// The credit options for the users.
    private let availableCredits = [10, 25, 50, 100, 250, 500]
    
    /// Initial credits added.
    private var creditsAdded = 1
    
    /// The delegate for this view controller.
    weak var delegate: AddGameCreditViewControllerDelegate?
    
    // MARK: UI Components
    
    /// The main title label.
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ADD CREDITS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemYellow
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowRadius = 8.0
        label.layer.masksToBounds = false
        return label
    }()
    
    /// The add credits amount picker.
    private var depositPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    /// Add credits button.
    private var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ADD", for: .normal)
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
        setDelegates()
    }
    
    // MARK: Setup
    
    /// Assigned the delegates for this view controller.
    func setDelegates() {
        depositPickerView.delegate = self
        depositPickerView.dataSource = self
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.primaryBackground
        view.layer.borderColor = UIColor.systemYellow.cgColor
        view.layer.borderWidth = 4.0
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        
        view.addSubview(titleLabel)
        view.addSubview(depositPickerView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 75),
            
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 75),
            
            depositPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            depositPickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            depositPickerView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20),
        ])
    }
    
    // MARK: Actions
    
    func setupActions() {
        addButton.addTarget(self, action: #selector(addCredits), for: .touchUpInside)
    }
    
    /// Add credits to the slot machine.
    @objc func addCredits() {
        delegate?.didUpdateCreditAmount(amount: creditsAdded)
        dismiss(animated: true)
    }
}

// MARK: Delegates

extension AddGameCreditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableCredits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        
        let label = UILabel()
        label.text = "$\(availableCredits[row])"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 84, weight: .bold)
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: 250, height: 75)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        creditsAdded = availableCredits[row]
    }
}
