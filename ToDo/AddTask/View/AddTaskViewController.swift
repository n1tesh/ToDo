//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Nitesh on 27/03/22.
//

import UIKit


protocol AddTaskViewControllerDelegate: AnyObject {
    func didAddTask(task: Task)
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var addTaskView: UIView!
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    
    @IBOutlet weak var submitButton: UIButton!
    weak var delegate: AddTaskViewControllerDelegate?
    private var viewModel = TaskViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let closeBarButtonItem = UIBarButtonItem(title: "close", style: .done, target: self, action: #selector(closeTask))
        self.navigationItem.rightBarButtonItem  = closeBarButtonItem
        self.taskDatePicker.minimumDate = viewModel.selectedDate
        self.taskDatePicker.setDate(viewModel.selectedDate, animated: false)
        self.viewModel.canSubmit.bind {[weak self] canSubmit in
            guard let weakSelf = self else { return }
            weakSelf.submitButton.isEnabled = canSubmit
        }


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.taskTitleTextField.becomeFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }
    @IBAction func taskDatePickerValueChanged(_ sender: UIDatePicker) {
        self.viewModel.selectedDate = sender.date
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.viewModel.addTask {[weak self] result in
            guard let weakSelf = self else{
                return
            }
            switch result{
            case .success(let task):
                weakSelf.delegate?.didAddTask(task: task)
                weakSelf.dismiss(animated: true)
            case .failure(_):
                break
            }
            
        }
    }
    
    deinit{
        print("DEINIT AddViewController")
    }
    
    @objc private func closeTask(){
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddTaskViewController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == taskTitleTextField {
            viewModel.taskTitle = textField.text ?? ""
        }else if textField == taskDescriptionTextField{
            viewModel.taskDescription = textField.text ?? ""
        }
    }
    
}
