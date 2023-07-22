//
//  TaskTableViewCell.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/17/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .systemBlue 
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        contentView.addSubview(taskLabel)
    }
    
    private func setupConstraints() {
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            taskLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func setup(with task: Task) {
        taskLabel.text = task.title
    }
}
