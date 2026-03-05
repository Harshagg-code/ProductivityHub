//
//  TaskCell.swift
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!

    var onCompleteButtonTapped: ((Task) -> Void)?
    var task: Task!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add priority indicator programmatically
        let indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.tag = 100
        indicator.layer.cornerRadius = 2
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            indicator.topAnchor.constraint(equalTo: contentView.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 4)
        ])
    }

    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
        task.isComplete = !task.isComplete
        update(with: task)
        onCompleteButtonTapped?(task)
    }

    func configure(with task: Task, onCompleteButtonTapped: ((Task) -> Void)?) {
        self.task = task
        self.onCompleteButtonTapped = onCompleteButtonTapped
        update(with: task)
    }

    private func update(with task: Task) {
        // Title and note
        titleLabel.text = task.title
        noteLabel.text = task.note
        noteLabel.isHidden = task.note == "" || task.note == nil
        
        // Complete button state
        completeButton.isSelected = task.isComplete
        completeButton.tintColor = task.isComplete ? .systemBlue : .tertiaryLabel
        
        // Overdue highlighting
        if !task.isComplete && task.dueDate < Date() {
            titleLabel.textColor = .systemRed
        } else {
            titleLabel.textColor = task.isComplete ? .secondaryLabel : .label
        }
        
        // Priority color bar
        if let indicator = contentView.viewWithTag(100) {
            switch task.priority {
            case .high: indicator.backgroundColor = .systemRed
            case .medium: indicator.backgroundColor = .systemOrange
            case .low: indicator.backgroundColor = .systemGreen
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) { }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) { }
}
