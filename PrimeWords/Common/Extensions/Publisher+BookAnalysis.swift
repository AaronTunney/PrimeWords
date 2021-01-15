//
//  Publisher+BookAnalysis.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation
import Combine
import RealmSwift

extension Publisher where Output == String {
    /// Creates a dictionary of words and word counts from a `String`
    func analyzeLine() -> AnyPublisher<[String: Int], Self.Failure> {
        return self
            .map { line in
                return line
                    .lowercased()
                    .split(separator: " ")
                    .map { String($0) }
                    .compactMap { word in
                        // This is going to struggle with hyphenated words.
                        let trimmedWord = word.trimmingCharacters(in: CharacterSet.lowercaseLetters.inverted)
                        return trimmedWord.isEmpty ? nil : trimmedWord
                    }
                    .reduce(into: [String: Int]()) { result, word in
                        result[word, default: 0] += 1
                    }
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == [[String: Int]] {
    /// Saves an array of words and word counts to Realm
    func saveToRealm(bookID: String, realmConfiguration: Realm.Configuration = .defaultConfiguration) -> AnyPublisher<Book, Error> {
        self
            .tryMap { dictionaries in
                let words: [String: Int] = dictionaries
                    .flatMap { $0 }
                    .reduce(into: [String: Int](), { result, word in
                        result[word.key, default: 0] += word.value
                    })

                let realm = try Realm(configuration: realmConfiguration)

                guard let book = realm.object(ofType: Book.self, forPrimaryKey: bookID) else {
                    throw PrimeWordsError.unableToRetrieveObject
                }

                try realm.write {
                    words.forEach { word, count in
                        let word = Word(name: word, count: count)
                        book.words.append(word)
                    }
                }

                return book
            }
            .eraseToAnyPublisher()
    }
}
