//
//  InitialLaunchViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/20/23.
//

import UIKit
import CLTypingLabel
import TextFieldEffects
import ChameleonFramework

class InitialLaunchViewController: UIViewController {
    
    var initialLaunchViewModel: InitialLaunchViewModel
    
    init(initialLaunchViewModel: InitialLaunchViewModel) {
        self.initialLaunchViewModel = initialLaunchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
    }
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont(name: "Futura", size: 30)
        label.text = "Welcome to Task Master!"
        return label
    }()
    
    private lazy var textFieldStack: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.textColor = .gray
        textField.isUserInteractionEnabled = true
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 8
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrowshape.right")

        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        
        let scale: CGFloat = 1.8
        button.transform = CGAffineTransform(scaleX: scale, y: scale)
        button.imageView?.transform = CGAffineTransform(scaleX: scale, y: scale)

        return button
    }()

    private func setupUI() {
        view.backgroundColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        
        textFieldStack.axis = .horizontal
        textFieldStack.translatesAutoresizingMaskIntoConstraints = false
        textFieldStack.spacing = 30
     }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(textFieldStack)
        textFieldStack.addArrangedSubview(nameTextField)
        textFieldStack.addArrangedSubview(nextButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 20),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 2),
            
            
            textFieldStack.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
            textFieldStack.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: textFieldStack.trailingAnchor, multiplier: 4)
        ])
    }
    
    @objc private func nextButtonClick() {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
                
        initialLaunchViewModel.saveUserName(name)
        navigateToTaskViewController()
    }
    
    private func navigateToTaskViewController() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let taskViewModel = TaskViewModel(context: context)
        let taskVC = TaskViewController(taskViewModel: taskViewModel)
        navigationController?.pushViewController(taskVC, animated: true)
    }
}
