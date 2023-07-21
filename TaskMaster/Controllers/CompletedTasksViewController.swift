//
//  CompletedTasksViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/18/23.
//

import UIKit
import CoreData

class CompletedTasksViewController: UIViewController, CompletedTasksViewModelDelegate {
    
    private let collectionCellReuseIdentifier = "collectionCell"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.completedTasksViewModel.delegate = self
        
        setupCollectionView()
        setupLayout()
        completedTasksViewModel.loadTasks()
        completedTasksViewModel.completedTasksChange()
        collectionView.reloadData()
    }
    
    var completedTasksViewModel: CompletedTasksViewModel
    
    init(completedTasksViewModel: CompletedTasksViewModel) {
        self.completedTasksViewModel = completedTasksViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
        
        completedTasksViewModel.loadTasks()
        completedTasksViewModel.completedTasksChange()
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    private lazy var searchBar: UISearchBar = {
         let searchBar = UISearchBar()
         searchBar.delegate = self
         searchBar.placeholder = "Search"
         return searchBar
     }()
    
    private lazy var completedTasksLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont(name: "Futura", size: 25)
        label.text = "You completed 0 tasks"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellReuseIdentifier)
        return collectionView
    }()
    
    private func setupLayout() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        completedTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        view.addSubview(completedTasksLabel)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            completedTasksLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            completedTasksLabel.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            completedTasksLabel.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: completedTasksLabel.bottomAnchor, multiplier: 2),
            collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: collectionView.trailingAnchor, multiplier: 1),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func completedTasksDidUpdate(count: Int) {
        print("count inside mainnn")
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.completedTasksLabel.text = "You completed \(count) tasks!"
        }
    }
}

// MARK: UISearchBarDelegate

extension CompletedTasksViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.predicate = titlePredicate
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

            completedTasksViewModel.loadTasks(with: request, predicate: titlePredicate)
        }
        searchBar.resignFirstResponder()
        self.collectionView.reloadData()
    }

   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchBar.text?.count == 0 {
           completedTasksViewModel.loadTasks()

           DispatchQueue.main.async {
               searchBar.resignFirstResponder()
           }
           self.collectionView.reloadData()
       }
   }
}

extension CompletedTasksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if completedTasksViewModel.completedTasks.count == 0 {
            collectionView.setEmptyView(title: "You don't have any tasks yet!", message: "Click the + button to add some tasks")
        } else {
            collectionView.restore()
        }
        
        return completedTasksViewModel.completedTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellReuseIdentifier, for: indexPath) as? TaskCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let task = completedTasksViewModel.task(at: indexPath.item)
        let cellViewModel = TaskCellViewModel(task: task!)
        cell.task = task
        cell.delegate = self
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
          return completedTasksViewModel.createContextMenuConfiguration(for: indexPath)
      }
}

extension CompletedTasksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
}

extension CompletedTasksViewController: TaskCellDelegate {
    func didToggleCheckbox(for cell: TaskCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        completedTasksViewModel.toggleCheckbox(for: indexPath)
        collectionView.reloadItems(at: [indexPath])
        
        let task = completedTasksViewModel.task(at: indexPath.item)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let index = self.completedTasksViewModel.completedTasks.firstIndex(where: { $0 == task }) {
                self.completedTasksViewModel.completedTasks.remove(at: index)
                self.completedTasksViewModel.saveTasks()
                self.collectionView.reloadData()
            }
        }
    }
}
