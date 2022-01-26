import Foundation

struct WordExample: Codable {
    let word: String
    let meaning: String
}

struct Kanji: Codable {
    let character: String
    let meaning: String
    let examples: [WordExample]
}
