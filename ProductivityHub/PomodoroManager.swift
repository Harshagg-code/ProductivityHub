//
//  PomodoroManager.swift
//  ios101-project7-task
//
//  Created by Harshit Aggarwal on 11/15/25.
//

import Foundation

class PomodoroManager {
    static let shared = PomodoroManager()
    private init() {}

    // The active task being focused on
    var activeTaskID: String?

    // Optional callback if you want to notify views later
    var onPomodoroComplete: (() -> Void)?
}
