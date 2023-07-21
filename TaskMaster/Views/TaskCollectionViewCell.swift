//
//  TaskCollectionViewCell.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit
import ChameleonFramework

class TaskCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: TaskCellDelegate?
    var task: Task?
        
    let LabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 27, weight: .regular)
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        return label
    }()
    
    private let checkboxButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        return button
    }()
    
    var viewModel: TaskCellViewModel? {
        didSet {
            checkboxButton.setImage(viewModel?.checkboxImage, for: .normal)
            configureCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        
        LabelsStackView.axis = .vertical
        LabelsStackView.spacing = 1
        LabelsStackView.alignment = .leading
    
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        contentView.addSubview(checkboxButton)
        contentView.addSubview(LabelsStackView)
        LabelsStackView.addArrangedSubview(dateLabel)
        LabelsStackView.addArrangedSubview(taskLabel)
                
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        LabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkboxButton.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: checkboxButton.trailingAnchor, multiplier: 2),
            
            LabelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            LabelsStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2)
        ])
    }
    
     func configureCell() {
        guard let viewModel = viewModel else { return }
        
        taskLabel.text = viewModel.taskTitle
        dateLabel.text = viewModel.taskDueDate
        let checkboxImageName = viewModel.task.isCompleted ? "checkmark.circle" : "circle"
        
         guard let color = UIColor(hexString: viewModel.taskColor ?? "000") else {
            return
        }

        taskLabel.textColor = ContrastColorOf(color, returnFlat: true)
        dateLabel.textColor = ContrastColorOf(color, returnFlat: true)
        backgroundColor = color
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
        let image = UIImage(systemName: checkboxImageName, withConfiguration: imageConfiguration)
        checkboxButton.setImage(image, for: .normal)
    }
    
    @objc private func toggleCheckbox() {
        delegate?.didToggleCheckbox(for: self)
    }
}
