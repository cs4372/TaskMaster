//
//  TaskViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit

class TaskViewController: UIViewController {
    
    private var taskViewModel: TaskViewModel!
    
    private let cellReuseIdentifier = "collectionCell"
    
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
                
        

     }
    
    private func setupLayout() {
        view.addSubview(rootStackView)
        rootStackView.addSubview(topStackView)
        topStackView.addSubview(topLeftStackView)
        topLeftStackView.addArrangedSubview(nameLabel)
        topLeftStackView.addArrangedSubview(dateLabel)
        topStackView.addSubview(segmentedControl)
        rootStackView.addSubview(collectionView)

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
        ])
        
    }
}

extension TaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! TaskCollectionViewCell
//
//        let task = taskViewModel.task(at: indexPath.item)
//        cell.setup(with: task)
//
        return cell
    }
}

extension TaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
}


