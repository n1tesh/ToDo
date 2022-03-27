//
//  ViewController.swift
//  ToDo
//
//  Created by Nitesh on 24/03/22.
//

import UIKit

class HomeViewController: UIViewController {
    

    @IBOutlet weak var taskListSegmentControl: UISegmentedControl!
    @IBOutlet weak var tasksTableView: UITableView!
    private var viewModel: HomeViewModel = HomeViewModel()
    
    @IBOutlet weak var addTaskButton: UIButton!
    fileprivate var tasks: [Task] = []{
        didSet{
            DispatchQueue.main.async {
                self.tasksTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "To Do List"
        self.addTaskButton.layer.cornerRadius = self.addTaskButton.frame.size.width/2
        self.addTaskButton.clipsToBounds = true
        
        self.setUpSegmentControls()
        self.bind()
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.calendarDayDidChange(_:)), name:NSNotification.Name.NSCalendarDayChanged, object:nil)
                
    }
    
    @IBAction func addTaskButtonAction(_ sender: Any) {
        if let addTaskVC = storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController{
            addTaskVC.delegate = self
            let navigationController = UINavigationController(rootViewController: addTaskVC)
            navigationController.modalPresentationStyle = .custom
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func taskListSegmentControlValueChanged(_ sender: UISegmentedControl) {
        self.viewModel.selectedSegmentIndex = sender.selectedSegmentIndex
    }
    
    @objc private func calendarDayDidChange(_ notification : NSNotification) {
        DispatchQueue.main.async {
            self.viewModel.selectedSegmentIndex = self.taskListSegmentControl.selectedSegmentIndex
        }
    }
    
    private func setUpSegmentControls(){
        self.taskListSegmentControl.removeAllSegments()
        self.viewModel.getAllSegments().enumerated().forEach {
            self.taskListSegmentControl.insertSegment(withTitle: $1.description, at: $0, animated: true)
        }
        
        self.taskListSegmentControl.selectedSegmentIndex = 0
        self.viewModel.selectedSegmentIndex = 0
    }
    
    private func bind(){
        self.viewModel.errorMessage.bind {[weak self] errorMessage in
            guard let weakSelf = self else { return }
            guard let errorMessage = errorMessage, !errorMessage.isWhitespace else {
                return
            }
            weakSelf.showAlert(title: nil, message: errorMessage, buttonTitles: nil, highlightedButtonIndex: nil, completion: nil)
        }
        
        self.viewModel.tasks.bind {[weak self] tasks in
            guard let weakSelf = self else { return }
            weakSelf.tasks = tasks
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tasks.count == 0 {
            self.tasksTableView.setEmptyMessage("Tap + to add task.")
        } else {
            self.tasksTableView.restore()
        }
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellIdentifier, for: indexPath) as! TaskTableViewCell
        cell.task = self.tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] action in
                guard let weakSelf = self else { return }
                let task  = weakSelf.tasks[indexPath.row]
                weakSelf.viewModel.deleteTask(task: task)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
}

extension HomeViewController: AddTaskViewControllerDelegate{
    
    func didAddTask(task: Task) {
        viewModel.didAddTask(task: task)
        viewModel.selectedSegmentIndex = self.taskListSegmentControl.selectedSegmentIndex
    }
    
}
