import Foundation

/// Represents a single answer option displayed to the user.
/// `resultID` is used to score the quiz (e.g., "A", "B", "C", "D").
struct Answer {
    let text: String
    let imageName: String
    let resultID: String
}

/// Represents a single question in a quiz.
struct Question {
    let text: String
    let type: QuestionType
    let answers: [Answer]
}

/// Represents an entire quiz (category + its questions).
struct Quiz {
    let id: String
    let title: String
    let questions: [Question]
}

/// Represents the final computed result that will be displayed on the Results screen.
struct QuizResult {
    let quizTitle: String
    let resultTitle: String
    let resultDescription: String
    let dominantResultID: String
}
