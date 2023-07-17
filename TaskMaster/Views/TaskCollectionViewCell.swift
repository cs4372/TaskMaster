//
//  TaskCollectionViewCell.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let checkboxButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        return button
    }()
    
    var viewModel: TaskCellViewModel? {
        didSet {
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
        contentView.backgroundColor = .orange
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        contentView.addSubview(taskLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(checkboxButton)
        
        // Add constraints for labels and button
        
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureCell() {
        guard let viewModel = viewModel else { return }
        
        taskLabel.text = "abc"
//        taskLabel.text = viewModel.taskTitle
//        dateLabel.text = viewModel.taskDueDate
//        contentView.backgroundColor = viewModel.taskColor
//        checkboxButton.setImage(viewModel.checkboxImage, for: .normal)
    }
}
