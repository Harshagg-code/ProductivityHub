//
//  TaskComposeViewController.swift
//

import UIKit

class TaskComposeViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var priorityControl: UISegmentedControl!

   // @IBOutlet weak var priorityControl: UISegmentedControl!
    var taskToEdit: Task?
    var onComposeTask: ((Task) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if let task = taskToEdit {
            titleField.text = task.title
            noteField.text = task.note
            datePicker.date = task.dueDate
            self.title = "Edit Task"

            // Set priority picker to match existing task
            switch task.priority {
            case .high: priorityControl.selectedSegmentIndex = 0
            case .medium: priorityControl.selectedSegmentIndex = 1
            case .low: priorityControl.selectedSegmentIndex = 2
            }
        } else {
            // Default to medium for new tasks
            priorityControl.selectedSegmentIndex = 1
        }
    }

    @IBAction func didTapDoneButton(_ sender: Any) {
        guard let title = titleField.text,
              !title.isEmpty
        else {
            presentAlert(title: "Oops...", message: "Make sure to add a title!")
            return
        }

        // Get priority from segmented control
        let priority: Task.Priority
        switch priorityControl.selectedSegmentIndex {
        case 0: priority = .high
        case 1: priority = .medium
        default: priority = .low
        }

        var task: Task

        if let editTask = taskToEdit {
            // Editing existing task
            task = editTask
            task.title = title
            task.note = noteField.text
            task.dueDate = datePicker.date
            task.priority = priority
        } else {
            // Creating new task
            task = Task(title: title,
                        note: noteField.text,
                        dueDate: datePicker.date,
                        priority: priority)
        }

        onComposeTask?(task)
        dismiss(animated: true)
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }

    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
