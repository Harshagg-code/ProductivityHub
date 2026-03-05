//
//  Habit.swift
//

import Foundation

struct Habit: Codable {
    var title: String
    var history: [String: Bool] = [:]
    var createdDate = Date()
    private(set) var id: String = UUID().uuidString

    // MARK: - Date Helpers
    private func dateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // Check if habit was completed today
    var isCompletedToday: Bool {
        return history[dateString(for: Date())] == true
    }

    // Toggle today's completion
    mutating func toggleToday() {
        let key = dateString(for: Date())
        history[key] = !(history[key] ?? false)
    }

    // Calculate current streak
    var streak: Int {
        var count = 0
        var date = Date()
        let calendar = Calendar.current

        // If not done today, start checking from yesterday
        if !isCompletedToday {
            date = calendar.date(byAdding: .day, value: -1, to: date) ?? date
        }

        while true {
            let key = dateString(for: date)
            if history[key] == true {
                count += 1
                date = calendar.date(byAdding: .day, value: -1, to: date) ?? date
            } else {
                break
            }
        }
        return count
    }

    // Get last 7 days completion status for the dot grid
    var lastSevenDays: [Bool] {
        let calendar = Calendar.current
        return (0..<7).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            return history[dateString(for: date)] == true
        }
    }
}

// MARK: - Persistence
extension Habit {
    static func saveAll(_ habits: [Habit]) {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: "Habits")
        }
    }

    static func getAll() -> [Habit] {
        guard let data = UserDefaults.standard.data(forKey: "Habits"),
              let habits = try? JSONDecoder().decode([Habit].self, from: data)
        else { return [] }
        return habits
    }
}
