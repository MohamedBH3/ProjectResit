import Foundation

// Defines the different supported question formats
enum QuestionType: String {
    case single     // User selects one answer
    case multiple   // User can select multiple answers
    case ranged     // User selects value via slider
}
