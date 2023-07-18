//
//  TaskViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit
import PanModal

class TaskViewController: UIViewController {
 
    enum DisplayMode {
         case collection
         case list
     }
     
    var displayMode: DisplayMode = .collection
    
    private var taskViewModel: TaskViewModel!
    private var addTaskViewModel: AddTaskViewModel!
    
    private let collectionCellReuseIdentifier = "collectionCell"
    private let tableCellReuseIdentifier = "tableCell"
    
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
        
        updateViews()
        setupUI()
        setupLayout()
        taskViewModel.loadTasks()
        print("displayMode ==>", displayMode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        taskViewModel.loadTasks()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellReuseIdentifier)
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellReuseIdentifier)
        return tableView
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
        segmentedControl.addTarget(self, action: #selector(viewTypeChanged(_:)), for: .valueChanged)
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
        button.backgroundColor = .systemBlue
        
        let plusImage = UIImage(systemName: "plus")
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        return button
    }()
    
    private func setupUI() {
        view.backgroundColor = .white

        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .vertical
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .horizontal
        topStackView.spacing = 10
        
        topLeftStackView.translatesAutoresizingMaskIntoConstraints = false
        topLeftStackView.axis = .vertical
        topLeftStackView.spacing = 5
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        rootStackView.addSubview(tableView)
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
            
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: topStackView.bottomAnchor, multiplier: 2),
            tableView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: rootStackView.bottomAnchor),

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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let addTaskViewModel = AddTaskViewModel(context: context)
        addTaskViewModel.delegate = self

        let addTaskViewController = AddTaskViewController(viewModel: addTaskViewModel)
         
         presentPanModal(addTaskViewController)
     }
    
    @IBAction func viewTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            displayMode = .collection
        case 1:
            displayMode = .list
        default:
            break
        }
        updateViews()
    }
    
    private func updateViews() {
        collectionView.isHidden = displayMode == .list
        tableView.isHidden = displayMode == .collection
    }
}

extension TaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskViewModel.numberOfTasks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellReuseIdentifier, for: indexPath) as? TaskCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let task = taskViewModel.task(at: indexPath.item)
        let cellViewModel = TaskCellViewModel(task: task)
        cell.viewModel = cellViewModel
        return cell
    }
}

extension TaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
}

extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskViewModel.numberOfTasks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath)
//        let task = taskViewModel.task(at: indexPath.item)
//        let cellViewModel = TaskCellViewModel(task: task)
//        print("task inside cellForItemAt ==>", task)
//        cell.viewModel = cellViewModel
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
        print("Selected row: \(indexPath.row)")
    }
}

extension TaskViewController: AddTaskViewDelegate {
    func didAddTask(_ task: Task) {
        taskViewModel.addTask(newTask: task)
        print("inside TaskViewController add task")
        taskViewModel.saveTasks()
        collectionView.reloadData()
//        tableView.reloadData()
    }
    
    func didEditTask(_ task: Task) {
        return
    }
    
    func didSaveTask(_ task: Task) {
//        taskViewModel.addTask(newTask: task)
//        taskViewModel.saveTasks()
//        collectionView.reloadData()
////        tableView.reloadData()
    }
}
