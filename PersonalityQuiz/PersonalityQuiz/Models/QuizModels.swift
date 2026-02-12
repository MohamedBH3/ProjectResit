import Foundation

// Represents a single answer option
struct Answer {
    let text: String          // Display text
    let imageName: String     // Associated image asset name
    let resultID: String      // Used later for result calculation
}

// Represents a question in the quiz
struct Question {
    let text: String              // Question title
    let type: QuestionType        // Question type (single/multiple/ranged)
    let answers: [Answer]         // Possible answers
}

// Represents an entire quiz category
struct Quiz {
    let id: String                // Unique identifier
    let title: String             // Quiz title
    let questions: [Question]     // All questions for this quiz
}
