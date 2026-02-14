//
//  QuizHistoryEntry.swift
//  PersonalityQuiz
//
//  Created by ec2-user on 14/02/2026.
//


import Foundation

struct QuizHistoryEntry: Codable {
    let quizTitle: String
    let resultTitle: String
    let completedAt: Date
}

final class QuizHistoryStore {

    static let shared = QuizHistoryStore()

    private let key = "quiz_history_entries"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {}

    func load() -> [QuizHistoryEntry] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try decoder.decode([QuizHistoryEntry].self, from: data)
        } catch {
            return []
        }
    }

    func save(_ entries: [QuizHistoryEntry]) {
        do {
            let data = try encoder.encode(entries)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            // If this fails, we silently ignore for now (you can log later).
        }
    }

    func add(_ entry: QuizHistoryEntry) {
        var entries = load()
        entries.insert(entry, at: 0) // newest first
        save(entries)
    }

    func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}