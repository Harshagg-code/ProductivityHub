//
//  PomodoroViewController.swift
//  ios101-project7-task
//
//  Created by Harshit Aggarwal on 11/15/25.
//

//
//  PomodoroViewController.swift
//  Productivity Hub
//
//  Created by Harshit Aggarwal on 11/15/25.
//

import UIKit

class PomodoroViewController: UIViewController {

    private var timer: Timer?
    private var totalSeconds = 2 * 60
    private var remainingSeconds = 2 * 60
    private var isRunning = false
    private var isBreak = false
    private var completedPomodoros = 0

    private let timeLabel = UILabel()
    private let startPauseButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let durationControl = UISegmentedControl(items: ["2", "30", "35"])
    private let progressLayer = CAShapeLayer()
    private let backgroundCircle = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pomodoro"
        setupUI()
        setupProgressCircle()
        updateTimeLabel()
        durationChanged() // ensures selected duration is applied
    }

    // MARK: - UI Setup
    private func setupUI() {
        durationControl.selectedSegmentIndex = 0
        durationControl.addTarget(self, action: #selector(durationChanged), for: .valueChanged)
        durationControl.selectedSegmentTintColor = UIColor.systemOrange
        durationControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        durationControl.setTitleTextAttributes([.foregroundColor: UIColor.systemOrange], for: .normal)
        durationControl.translatesAutoresizingMaskIntoConstraints = false

        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50, weight: .semibold)
        timeLabel.textColor = .label
        timeLabel.textAlignment = .center

        startPauseButton.setTitle("Start", for: .normal)
        startPauseButton.setTitleColor(.systemOrange, for: .normal)
        startPauseButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        startPauseButton.addTarget(self, action: #selector(startPauseTapped), for: .touchUpInside)

        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.systemGray, for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [startPauseButton, resetButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 40

        let mainStack = UIStackView(arrangedSubviews: [durationControl, timeLabel, buttonStack])
        mainStack.axis = .vertical
        mainStack.spacing = 32
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Progress Circle
//    private func setupProgressCircle() {
//        view.layoutIfNeeded()
//
//        // Make sure layers don’t get duplicated if function is called again
//        backgroundCircle.removeFromSuperlayer()
//        progressLayer.removeFromSuperlayer()
//
//        // Position circle around the timer label
//        let labelCenter = timeLabel.superview!.convert(timeLabel.center, to: view)
//        let radius: CGFloat = 150
//        let centerPoint = CGPoint(x: labelCenter.x, y: labelCenter.y)
//
//        // Background circle (gray ring)
//        let backgroundPath = UIBezierPath(arcCenter: centerPoint,
//                                          radius: radius,
//                                          startAngle: -.pi / 2,
//                                          endAngle: 1.5 * .pi,
//                                          clockwise: true)
//        backgroundCircle.path = backgroundPath.cgPath
//        backgroundCircle.strokeColor = UIColor.systemGray5.cgColor
//        backgroundCircle.lineWidth = 10
//        backgroundCircle.fillColor = UIColor.clear.cgColor
//
//        // Progress circle (orange ring)
//        let circularPath = UIBezierPath(arcCenter: centerPoint,
//                                        radius: radius,
//                                        startAngle: -.pi / 2,
//                                        endAngle: 1.5 * .pi,
//                                        clockwise: true)
//        progressLayer.path = circularPath.cgPath
//        progressLayer.strokeColor = UIColor.systemOrange.cgColor
//        progressLayer.lineWidth = 10
//        progressLayer.fillColor = UIColor.clear.cgColor
//        progressLayer.lineCap = .round
//        progressLayer.strokeEnd = 1.0  // start full
//
//        // Add them in the right order (gray below, orange above)
//        //view.layer.insertSublayer(backgroundCircle, at: 0)
//        //view.layer.insertSublayer(progressLayer, above: backgroundCircle)
//
//        view.layer.addSublayer(progressLayer)
//    }
    
    private func setupProgressCircle() {
        view.layoutIfNeeded()
        
        // Get position of the timer label relative to the whole view
        let labelCenter = timeLabel.superview!.convert(timeLabel.center, to: view)
        let radius: CGFloat = 180
        let centerPoint = CGPoint(x: labelCenter.x, y: labelCenter.y)
        
        // Background circle
        let backgroundPath = UIBezierPath(arcCenter: centerPoint,
                                          radius: radius,
                                          startAngle: -.pi / 2,
                                          endAngle: 1.5 * .pi,
                                          clockwise: true)
        backgroundCircle.path = backgroundPath.cgPath
        backgroundCircle.strokeColor = UIColor.systemGray5.cgColor
        backgroundCircle.lineWidth = 10
        backgroundCircle.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(backgroundCircle)
        
        // Orange progress ring
        let circularPath = UIBezierPath(arcCenter: centerPoint,
                                        radius: radius,
                                        startAngle: -.pi / 2,
                                        endAngle: 1.5 * .pi,
                                        clockwise: true)
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.systemOrange.cgColor
        progressLayer.lineWidth = 10
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 1
        view.layer.addSublayer(progressLayer)
    }

//    private func updateProgress() {
//        CATransaction.begin()
//        CATransaction.setDisableActions(true) // prevents flicker
//        
//        // Compute progress (1 → 0)
//        let progress = CGFloat(remainingSeconds) / CGFloat(totalSeconds)
//        print("Progress:", progress) // Debug line
//        
//        progressLayer.strokeEnd = progress
//        progressLayer.setNeedsDisplay() // force redraw
//        
//        CATransaction.commit()
//    }
    
    private func updateProgress() {
            let progress = CGFloat(remainingSeconds) / CGFloat(totalSeconds)
            progressLayer.strokeEnd = progress
        }




    private func updateTimeLabel() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        updateProgress()   // 👈 MUST be called here
    }


    // MARK: - Timer Controls
    @objc private func startPauseTapped() {
        if isRunning {
            timer?.invalidate()
            isRunning = false
            startPauseButton.setTitle("Start", for: .normal)
            startPauseButton.setTitleColor(.systemOrange, for: .normal)
        } else {
            isRunning = true
            startPauseButton.setTitle("Pause", for: .normal)
            startPauseButton.setTitleColor(.systemRed, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
        }
    }

    @objc private func resetTapped() {
        timer?.invalidate()
        remainingSeconds = totalSeconds
        isRunning = false
        updateTimeLabel()
        startPauseButton.setTitle("Start", for: .normal)
        startPauseButton.setTitleColor(.systemOrange, for: .normal)
    }

    @objc private func updateTimer() {
        guard remainingSeconds > 0 else {
            timer?.invalidate()
            isRunning = false
            showBreakAlert()
            return
        }
        
        
        remainingSeconds -= 1
        updateTimeLabel()   // 👈 this is what drives the circle + label
    }

    @objc private func durationChanged() {
        let selectedMinutes = [2, 30, 35][durationControl.selectedSegmentIndex]
        totalSeconds = selectedMinutes * 60
        remainingSeconds = totalSeconds
        updateTimeLabel()
        resetTapped()
    }

    // MARK: - Break & Auto Cycle Logic
    private func showBreakAlert() {
        if isBreak {
            // Break ended → start next Pomodoro
            isBreak = false
            totalSeconds = 25 * 60
            remainingSeconds = totalSeconds
            updateTimeLabel()

            let alert = UIAlertController(title: "Break Over ☕️",
                                          message: "Let’s get back to work!",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Start Next Pomodoro", style: .default, handler: { _ in
                self.startPauseTapped()
            }))
            present(alert, animated: true)
        } else {
            // Pomodoro ended → start break
            completedPomodoros += 1
            isBreak = true
            let isLongBreak = completedPomodoros % 4 == 0
            totalSeconds = isLongBreak ? 25 * 60 : 10 * 60
            remainingSeconds = totalSeconds
            updateTimeLabel()

            // ✅ Mark linked task as complete if applicable
            if let taskID = PomodoroManager.shared.activeTaskID {
                var allTasks = Task.getTasks()
                if let index = allTasks.firstIndex(where: { $0.id == taskID }) {
                    allTasks[index].isComplete = true
                    Task.save(allTasks)
                }
                PomodoroManager.shared.activeTaskID = nil
            }

            let alert = UIAlertController(title: "Nice Work!",
                                          message: isLongBreak
                                          ? "🎉 You’ve finished 4 Pomodoros! Take a long 25-minute break."
                                          : "🎉 Great job! Take a 10-minute break.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Start Break", style: .default, handler: { _ in
                self.startPauseTapped()
            }))
            present(alert, animated: true)
        }
    }
}
