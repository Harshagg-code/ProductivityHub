//
//  HabitCell.swift
//

import UIKit

class HabitCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let priorityBar = UIView()
    private let titleLabel = UILabel()
    private let streakLabel = UILabel()
    private let checkButton = UIButton(type: .system)
    private let dotStackView = UIStackView()
    
    // MARK: - Properties
    var onCheckTapped: (() -> Void)?
    private var habit: Habit?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        
        // Priority bar on left edge
        priorityBar.translatesAutoresizingMaskIntoConstraints = false
        priorityBar.layer.cornerRadius = 2
        priorityBar.backgroundColor = .systemBlue
        contentView.addSubview(priorityBar)
        
        // Title label
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Streak label
        streakLabel.font = .systemFont(ofSize: 13, weight: .medium)
        streakLabel.textColor = .secondaryLabel
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(streakLabel)
        
        // 7-day dot grid
        dotStackView.axis = .horizontal
        dotStackView.spacing = 4
        dotStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dotStackView)
        
        // Check button
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkTapped), for: .touchUpInside)
        contentView.addSubview(checkButton)
        
        // MARK: - Constraints
        NSLayoutConstraint.activate([
            // Priority bar
            priorityBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priorityBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            priorityBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            priorityBar.widthAnchor.constraint(equalToConstant: 4),
            
            // Check button
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 32),
            checkButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Title label
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -8),
            
            // Streak label
            streakLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            streakLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            // Dot stack view
            dotStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dotStackView.topAnchor.constraint(equalTo: streakLabel.bottomAnchor, constant: 6),
            dotStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    // MARK: - Configure
    func configure(with habit: Habit, onCheckTapped: @escaping () -> Void) {
        self.habit = habit
        self.onCheckTapped = onCheckTapped
        
        titleLabel.text = habit.title
        
        // Streak
        let streak = habit.streak
        streakLabel.text = streak > 0 ? "🔥 \(streak) day streak" : "No streak yet"
        
        // Check button
        let isComplete = habit.isCompletedToday
        let imageName = isComplete ? "checkmark.circle.fill" : "circle"
        checkButton.setImage(UIImage(systemName: imageName), for: .normal)
        checkButton.tintColor = isComplete ? .systemGreen : .tertiaryLabel
        
        // Priority bar color based on streak
        if streak >= 7 {
            priorityBar.backgroundColor = .systemGreen
        } else if streak >= 3 {
            priorityBar.backgroundColor = .systemOrange
        } else {
            priorityBar.backgroundColor = .systemBlue
        }
        
        // 7-day dots
        dotStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let days = habit.lastSevenDays
        for completed in days {
            let dot = UIView()
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.layer.cornerRadius = 5
            dot.backgroundColor = completed ? .systemGreen : .systemGray5
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 10),
                dot.heightAnchor.constraint(equalToConstant: 10)
            ])
            dotStackView.addArrangedSubview(dot)
        }
    }
    
    @objc private func checkTapped() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
        onCheckTapped?()
    }
}
