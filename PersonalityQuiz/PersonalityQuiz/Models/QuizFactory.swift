import Foundation

/// Creates quiz content based on the selected category.
/// Keeps view controllers free of hardcoded quiz data.
enum QuizFactory {

    static func makeQuestions(for categoryTitle: String) -> [Question] {
        let questions: [Question]

        switch categoryTitle {
        case "Food Quiz":
            questions = foodQuestions()
        case "Animal Quiz":
            questions = animalQuestions()
        case "Music Quiz":
            questions = musicQuestions()
        default:
            questions = foodQuestions()
        }

        // Randomize each run.
        return questions.shuffled().map { shuffledAnswersIfNeeded($0) }
    }

    // MARK: - Food Quiz (10 total: 4 single, 3 multiple, 3 ranged)

    private static func foodQuestions() -> [Question] {
        [
            // 4 SINGLE
            Question(
                text: "Pick a main dish.",
                type: .single,
                answers: fourWay(
                    ("Pizza", "fork.knife"),
                    ("Burger", "fork.knife.circle.fill"),
                    ("Salad", "leaf"),
                    ("Soup", "cup.and.saucer")
                )
            ),
            Question(
                text: "Pick a drink.",
                type: .single,
                answers: fourWay(
                    ("Coffee", "cup.and.saucer"),
                    ("Tea", "cup.and.saucer"),
                    ("Soda", "takeoutbag.and.cup.and.straw"),
                    ("Water", "drop")
                )
            ),
            Question(
                text: "Pick a dessert.",
                type: .single,
                answers: fourWay(
                    ("Cake", "sparkles"),
                    ("Ice cream", "snowflake"),
                    ("Chocolate", "heart"),
                    ("Fruit", "leaf")
                )
            ),
            Question(
                text: "Pick a snack.",
                type: .single,
                answers: fourWay(
                    ("Chips", "takeoutbag.and.cup.and.straw"),
                    ("Nuts", "leaf"),
                    ("Yogurt", "cart"),
                    ("Popcorn", "film.fill")
                )
            ),

            // 3 MULTIPLE
            Question(
                text: "Which flavors do you enjoy?",
                type: .multiple,
                answers: fourWay(
                    ("Sweet", "heart"),
                    ("Spicy", "flame"),
                    ("Savory", "fork.knife"),
                    ("Sour", "bolt")
                )
            ),
            Question(
                text: "Which foods do you crave most often?",
                type: .multiple,
                answers: fourWay(
                    ("Comfort food", "house"),
                    ("Healthy", "leaf"),
                    ("Fast food", "takeoutbag.and.cup.and.straw"),
                    ("Fancy meals", "sparkles")
                )
            ),
            Question(
                text: "What matters most when choosing food?",
                type: .multiple,
                answers: fourWay(
                    ("Taste", "star"),
                    ("Health", "heart"),
                    ("Speed", "clock"),
                    ("Price", "dollarsign.circle")
                )
            ),

            // 3 RANGED
            Question(
                text: "How adventurous are you with food?",
                type: .ranged,
                answers: rangedEndpoints("I stick to favorites", "I try anything")
            ),
            Question(
                text: "How spicy do you like your food?",
                type: .ranged,
                answers: rangedEndpoints("Mild", "Very spicy")
            ),
            Question(
                text: "How often do you eat out vs cook at home?",
                type: .ranged,
                answers: rangedEndpoints("Mostly home", "Mostly out")
            )
        ]
    }

    // MARK: - Animal Quiz (10 total: 4 single, 3 multiple, 3 ranged)

    private static func animalQuestions() -> [Question] {
        [
            // 4 SINGLE
            Question(
                text: "Pick your energy level.",
                type: .single,
                answers: fourWay(
                    ("Fast", "hare"),
                    ("Steady", "figure.walk"),
                    ("Slow", "tortoise"),
                    ("Depends", "shuffle")
                )
            ),
            Question(
                text: "Pick a habitat.",
                type: .single,
                answers: fourWay(
                    ("Ocean", "water.waves"),
                    ("Forest", "leaf"),
                    ("Mountains", "mountain.2"),
                    ("City", "building.2")
                )
            ),
            Question(
                text: "Pick a time of day you feel best.",
                type: .single,
                answers: fourWay(
                    ("Morning", "sunrise"),
                    ("Day", "sun.max"),
                    ("Evening", "sunset"),
                    ("Night", "moon.stars")
                )
            ),
            Question(
                text: "Pick a vibe.",
                type: .single,
                answers: fourWay(
                    ("Brave", "shield"),
                    ("Playful", "gamecontroller"),
                    ("Independent", "person"),
                    ("Social", "person.3")
                )
            ),

            // 3 MULTIPLE
            Question(
                text: "What traits describe you?",
                type: .multiple,
                answers: fourWay(
                    ("Curious", "magnifyingglass"),
                    ("Loyal", "heart"),
                    ("Calm", "cloud"),
                    ("Bold", "bolt")
                )
            ),
            Question(
                text: "What do you value most?",
                type: .multiple,
                answers: fourWay(
                    ("Freedom", "bird"),
                    ("Comfort", "house"),
                    ("Adventure", "map"),
                    ("Routine", "calendar")
                )
            ),
            Question(
                text: "How do you recharge?",
                type: .multiple,
                answers: fourWay(
                    ("Sleep", "bed.double"),
                    ("Music", "headphones"),
                    ("Friends", "person.2"),
                    ("Alone time", "moon")
                )
            ),

            // 3 RANGED
            Question(
                text: "How social are you?",
                type: .ranged,
                answers: rangedEndpoints("Mostly solo", "Always with people")
            ),
            Question(
                text: "How spontaneous are you?",
                type: .ranged,
                answers: rangedEndpoints("Plan everything", "Go with the flow")
            ),
            Question(
                text: "How bold are you?",
                type: .ranged,
                answers: rangedEndpoints("Cautious", "Fearless")
            )
        ]
    }

    // MARK: - Music Quiz (10 total: 4 single, 3 multiple, 3 ranged)

    private static func musicQuestions() -> [Question] {
        [
            // 4 SINGLE
            Question(
                text: "Pick a listening mood.",
                type: .single,
                answers: fourWay(
                    ("Chill", "cloud"),
                    ("Hype", "bolt"),
                    ("Focus", "brain.head.profile"),
                    ("Emotional", "heart")
                )
            ),
            Question(
                text: "Where do you listen most?",
                type: .single,
                answers: fourWay(
                    ("Car", "car"),
                    ("Gym", "figure.run"),
                    ("Studying", "book"),
                    ("Party", "sparkles")
                )
            ),
            Question(
                text: "Pick a style you enjoy.",
                type: .single,
                answers: fourWay(
                    ("Acoustic", "guitars"),
                    ("Electronic", "waveform"),
                    ("Live vocals", "mic"),
                    ("Instrumental", "music.note")
                )
            ),
            Question(
                text: "How do you discover music?",
                type: .single,
                answers: fourWay(
                    ("Playlists", "music.note.list"),
                    ("Friends", "person.2"),
                    ("Social media", "bubble.left.and.bubble.right"),
                    ("Radio", "dot.radiowaves.left.and.right")
                )
            ),

            // 3 MULTIPLE
            Question(
                text: "What do you like most in a song?",
                type: .multiple,
                answers: fourWay(
                    ("Lyrics", "text.quote"),
                    ("Beat", "waveform"),
                    ("Vocals", "mic"),
                    ("Bass", "speaker.wave.2")
                )
            ),
            Question(
                text: "When do you listen most?",
                type: .multiple,
                answers: fourWay(
                    ("Morning", "sunrise"),
                    ("Work/Study", "laptopcomputer"),
                    ("Workout", "figure.run"),
                    ("Late night", "moon.stars")
                )
            ),
            Question(
                text: "What playlists do you save?",
                type: .multiple,
                answers: fourWay(
                    ("Relax", "leaf"),
                    ("Motivation", "bolt"),
                    ("Throwbacks", "clock.arrow.circlepath"),
                    ("New releases", "sparkles")
                )
            ),

            // 3 RANGED
            Question(
                text: "How open are you to new music?",
                type: .ranged,
                answers: rangedEndpoints("Same favorites", "Always exploring")
            ),
            Question(
                text: "How loud do you like your music?",
                type: .ranged,
                answers: rangedEndpoints("Quiet", "LOUD")
            ),
            Question(
                text: "How energetic is your taste in music?",
                type: .ranged,
                answers: rangedEndpoints("Calm", "High energy")
            )
        ]
    }

    // MARK: - Helpers

    private static func fourWay(
        _ a: (String, String),
        _ b: (String, String),
        _ c: (String, String),
        _ d: (String, String)
    ) -> [Answer] {
        [
            Answer(text: a.0, imageName: a.1, resultID: "A"),
            Answer(text: b.0, imageName: b.1, resultID: "B"),
            Answer(text: c.0, imageName: c.1, resultID: "C"),
            Answer(text: d.0, imageName: d.1, resultID: "D")
        ]
    }

    private static func rangedEndpoints(_ left: String, _ right: String) -> [Answer] {
        [
            Answer(text: left, imageName: "", resultID: "A"),
            Answer(text: right, imageName: "", resultID: "D")
        ]
    }

    private static func shuffledAnswersIfNeeded(_ question: Question) -> Question {
        switch question.type {
        case .single, .multiple:
            return Question(text: question.text, type: question.type, answers: question.answers.shuffled())
        case .ranged:
            return question
        }
    }
}
