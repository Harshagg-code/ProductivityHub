//
//  HabitListViewController.swift
//

import UIKit

class HabitListViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let emptyStateLabel = UILabel()
    
    // MARK: - Properties
    private var habits = [Habit]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Habits"
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        setupEmptyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshHabits()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HabitCell.self, forCellReuseIdentifier: "HabitCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyState() {
        emptyStateLabel.text = "No habits yet!\nTap + to add your first habit"
        emptyStateLabel.numberOfLines = 2
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Habit", message: "What habit do you want to build?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "e.g. Exercise, Read, Meditate"
            textField.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?.first?.text,
                  !title.isEmpty else { return }
            let newHabit = Habit(title: title)
            var habits = Habit.getAll()
            habits.append(newHabit)
            Habit.saveAll(habits)
            self?.refreshHabits()
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Helpers
    private func refreshHabits() {
        habits = Habit.getAll()
        emptyStateLabel.isHidden = !habits.isEmpty
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension HabitListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! HabitCell
        let habit = habits[indexPath.row]
        
        cell.configure(with: habit) { [weak self] in
            guard let self = self else { return }
            var updatedHabit = self.habits[indexPath.row]
            updatedHabit.toggleToday()
            var allHabits = Habit.getAll()
            if let index = allHabits.firstIndex(where: { $0.id == updatedHabit.id }) {
                allHabits[index] = updatedHabit
                Habit.saveAll(allHabits)
            }
            self.refreshHabits()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var allHabits = Habit.getAll()
            allHabits.remove(at: indexPath.row)
            Habit.saveAll(allHabits)
            habits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            emptyStateLabel.isHidden = !habits.isEmpty
        }
    }
}

// MARK: - TableView Delegate
extension HabitListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
