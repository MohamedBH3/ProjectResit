import Foundation

/// Creates quiz content based on the selected category.
/// Keeps view controllers free of hardcoded quiz data.
enum QuizFactory {

    static func makeQuestions(for categoryTitle: String) -> [Question] {
        switch categoryTitle {
        case "Food Quiz":
            return foodQuestions()
        case "Animal Quiz":
            return animalQuestions()
        case "Music Quiz":
            return musicQuestions()
        default:
            return foodQuestions()
        }
    }

    private static func foodQuestions() -> [Question] {
        [
            Question(
                text: "Which food do you prefer?",
                type: .single,
                answers: [
                    Answer(text: "Pizza", imageName: "pizza", resultID: "A"),
                    Answer(text: "Sushi", imageName: "sushi", resultID: "B"),
                    Answer(text: "Burger", imageName: "burger", resultID: "C"),
                    Answer(text: "Salad", imageName: "salad", resultID: "D")
                ]
            ),
            Question(
                text: "Which flavors do you enjoy?",
                type: .multiple,
                answers: [
                    Answer(text: "Sweet", imageName: "sweet", resultID: "A"),
                    Answer(text: "Spicy", imageName: "spicy", resultID: "B"),
                    Answer(text: "Savory", imageName: "savory", resultID: "C"),
                    Answer(text: "Sour", imageName: "sour", resultID: "D")
                ]
            ),
            Question(
                text: "How much do you enjoy trying new foods?",
                type: .ranged,
                answers: [
                    Answer(text: "Not at all", imageName: "", resultID: "A"),
                    Answer(text: "Very much", imageName: "", resultID: "D")
                ]
            ),
            Question(text: "Pick a comfort meal.", type: .single, answers: sampleFoodAnswers()),
            Question(text: "Choose a drink.", type: .single, answers: sampleFoodAnswers()),
            Question(text: "Pick a dessert.", type: .single, answers: sampleFoodAnswers()),
            Question(text: "Select cuisines you like.", type: .multiple, answers: sampleFoodAnswers()),
            Question(text: "Pick a snack.", type: .single, answers: sampleFoodAnswers()),
            Question(text: "Select toppings you like.", type: .multiple, answers: sampleFoodAnswers()),
            Question(
                text: "How spicy do you like your food?",
                type: .ranged,
                answers: [
                    Answer(text: "Mild", imageName: "", resultID: "A"),
                    Answer(text: "Very spicy", imageName: "", resultID: "D")
                ]
            )
        ]
    }

    private static func animalQuestions() -> [Question] {
        Array(
            repeating: Question(text: "Animal question", type: .single, answers: sampleAnimalAnswers()),
            count: 10
        )
    }

    private static func musicQuestions() -> [Question] {
        Array(
            repeating: Question(text: "Music question", type: .single, answers: sampleMusicAnswers()),
            count: 10
        )
    }

    private static func sampleFoodAnswers() -> [Answer] {
        [
            Answer(text: "Option 1", imageName: "pizza", resultID: "A"),
            Answer(text: "Option 2", imageName: "sushi", resultID: "B"),
            Answer(text: "Option 3", imageName: "burger", resultID: "C"),
            Answer(text: "Option 4", imageName: "salad", resultID: "D")
        ]
    }

    private static func sampleAnimalAnswers() -> [Answer] {
        [
            Answer(text: "Lion", imageName: "lion", resultID: "A"),
            Answer(text: "Dolphin", imageName: "dolphin", resultID: "B"),
            Answer(text: "Owl", imageName: "owl", resultID: "C"),
            Answer(text: "Dog", imageName: "dog", resultID: "D")
        ]
    }

    private static func sampleMusicAnswers() -> [Answer] {
        [
            Answer(text: "Pop", imageName: "pop", resultID: "A"),
            Answer(text: "Rock", imageName: "rock", resultID: "B"),
            Answer(text: "Hip-Hop", imageName: "hiphop", resultID: "C"),
            Answer(text: "Classical", imageName: "classical", resultID: "D")
        ]
    }
}
