//
//  TaskViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit
import PanModal

class TaskViewController: UIViewController {
    
    private var taskViewModel: TaskViewModel!
    
    private let cellReuseIdentifier = "collectionCell"
    
    init(taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let rootStackView = UIStackView()
    let topStackView = UIStackView()
    let topLeftStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view?.backgroundColor = .white
        setupUI()
        setupLayout()

    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // Configure layout properties
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        return collectionView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont(name: "Futura", size: 25)
        label.text = "Hi Cat!"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
          let label = UILabel()
//          label.textColor = FlatSkyBlue()
        label.text = "Today is 16-Jul Sun"
        label.font = UIFont(name: "Futura", size: 25)
        return label
      }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
//        segmentedControl.addTarget(self, action: #selector(viewTypeChanged(_:)), for: .valueChanged)
        segmentedControl.insertSegment(withTitle: "Tile", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "List", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton()
        let buttonSize: CGFloat = 50.0
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.layer.cornerRadius = buttonSize / 2
        button.clipsToBounds = true
        button.backgroundColor = .blue
        
        let plusImage = UIImage(systemName: "plus")
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        return button
    }()
    
    private func setupUI() {
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .vertical
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .horizontal
        topStackView.spacing = 10
//        alignment = .top
        
        topLeftStackView.translatesAutoresizingMaskIntoConstraints = false
        topLeftStackView.axis = .vertical
        topLeftStackView.spacing = 5
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
                
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false

     }
    
    private func setupLayout() {
        view.addSubview(rootStackView)
        rootStackView.addSubview(topStackView)
        topStackView.addSubview(topLeftStackView)
        topLeftStackView.addArrangedSubview(nameLabel)
        topLeftStackView.addArrangedSubview(dateLabel)
        topStackView.addSubview(segmentedControl)
        rootStackView.addSubview(collectionView)
        rootStackView.addSubview(addTaskButton)

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 1),
            rootStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    
            topStackView.topAnchor.constraint(equalToSystemSpacingBelow: rootStackView.topAnchor, multiplier: 2),
            topStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.leadingAnchor, multiplier: 1),
            rootStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: topStackView.trailingAnchor, multiplier: 1),
            
            topLeftStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: topStackView.leadingAnchor, multiplier: 1),
            topLeftStackView.topAnchor.constraint(equalTo: topStackView.topAnchor),
            topStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: topLeftStackView.bottomAnchor, multiplier: 2),

            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: topStackView.bottomAnchor, multiplier: 2),
            collectionView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: rootStackView.bottomAnchor),

            segmentedControl.topAnchor.constraint(equalToSystemSpacingBelow: topStackView.topAnchor, multiplier: 2),
            topStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: segmentedControl.trailingAnchor, multiplier: 2),
            topStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: segmentedControl.bottomAnchor, multiplier: 5),
            
            rootStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: addTaskButton.bottomAnchor, multiplier: 5),
            rootStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: addTaskButton.trailingAnchor, multiplier: 2),
            addTaskButton.heightAnchor.constraint(equalToConstant: 50),
            addTaskButton.widthAnchor.constraint(equalToConstant: 50)

        ])
        
    }
    
    @objc func addTask() {
         let addTaskViewController = AddTaskViewController()
         
         presentPanModal(addTaskViewController)
     }

}

extension TaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? TaskCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.taskLabel.text = "Abc"
//
//        let task = tasks[indexPath.item]
//        let cellViewModel = TaskCellViewModel(task: task)
//        cell.viewModel = cellViewModel
        
        return cell
    }
}

extension TaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
}


