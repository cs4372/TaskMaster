//
//  CalendarViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/18/23.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    private var calendarViewModel: CalendarViewModel
    
    init(calendarViewModel: CalendarViewModel) {
        self.calendarViewModel = calendarViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var calendarView: FSCalendar = {
        calendarView = FSCalendar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 350))
        calendarView.dataSource = self
        calendarView.delegate = self
        return calendarView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "calendarCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        calendarViewModel.reloadData()
        tableView.reloadData()
        calendarView.reloadData()
        calendarView.appearance.titleDefaultColor = UIColor(named: "CalenderDateColor")
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarViewModel.reloadData()
        
        tableView.reloadData()
        calendarView.reloadData()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(calendarView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 300),
        
            tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }
    
    // MARK: - FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarViewModel.getSelectedDateTasks(date: date)
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return calendarViewModel.getNumberOfEventsByDate(date: date)
    }
}

// MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarViewModel.selectedTasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarTableViewCell
        
        if let task = calendarViewModel.selectedTasks?[indexPath.row] {
            cell.setup(with: task)
        }
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 50.0
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if calendarViewModel.selectedTasks == nil {
            tableView.setEmptyView(title: "You don't have any tasks on this date!", message: "")
        } else {
            tableView.restore()
            return calendarViewModel.selectedDate
        }
        return nil
    }
}
