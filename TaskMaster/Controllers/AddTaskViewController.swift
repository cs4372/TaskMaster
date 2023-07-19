//
//  AddTaskViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit
import PanModal

class AddTaskViewController: UIViewController {
    weak var delegate: AddTaskViewDelegate?
    var addTaskViewModel: AddTaskViewModel
    
    init(viewModel: AddTaskViewModel) {
        self.addTaskViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var dueDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter task"
        textField.font = UIFont.systemFont(ofSize: 30)
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
    
    private lazy var dueDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Due Date"
        return label
    }()
    
    private lazy var dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        return datePicker
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setupLayout()
        if let editTask = addTaskViewModel.editTask {
            dueDatePicker.date = editTask.dueDate!
            searchTextField.text = editTask.title!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         searchTextField.becomeFirstResponder()
     }
    
    private func setupLayout() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 5),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 4),
        ])
        
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(dueDateStackView)
        dueDateStackView.addArrangedSubview(dueDateLabel)
        dueDateStackView.addArrangedSubview(dueDatePicker)
        stackView.addArrangedSubview(saveButton)
    }
    
    @objc private func saveTask() {
          guard let title = searchTextField.text, !title.isEmpty else {
              return
          }
          
          let dueDate = dueDatePicker.date
          addTaskViewModel.saveTask(title: title, dueDate: dueDate)
          dismiss(animated: true, completion: nil)
      }
}

extension AddTaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        return newText.count <= 30
    }
}

// MARK: PanModalPresentable

extension AddTaskViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500)
    }
}
