//
//  Habit.swift
//  ios101-project7-task
//
//  Created by Harshit Aggarwal on 11/17/25.
//



import UIKit

import Foundation


struct Habit: Codable{
    var title: String                          // Habit name (e.g., “Drink Water”)
       var history: [String: Bool] = [:]          // date string → completed?
       var createdDate = Date()
}

extension Habit {
    // Save an array of habits
    static func saveAll(_ habits: [Habit]) {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: "Habits")
        }
    }

    // Load all habits
    static func getAll() -> [Habit] {
        guard let data = UserDefaults.standard.data(forKey: "Habits"),
              let habits = try? JSONDecoder().decode([Habit].self, from: data)
        else { return [] }
        return habits
    }
}


