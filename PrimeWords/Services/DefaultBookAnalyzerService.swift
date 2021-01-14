//
//  DefaultBookAnalyzerService.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation
import Combine
import os.log
import RealmSwift

// This is a relatively simple solution to reading the book in.
// A preferable solution would be to read the book in larger chunks and parallelize
// the analysis work using an operation queue to improve performance.
class DefaultBookAnalyzerService {
    var publisher: AnyPublisher<Int, Error>?
    let realmConfiguration: Realm.Configuration
    let bookURL: URL

    init(url: URL,
         realmConfiguration: Realm.Configuration = .defaultConfiguration) {
        self.bookURL = url
        self.realmConfiguration = realmConfiguration
    }

    func book() throws -> Book {
        let realm = try Realm(configuration: realmConfiguration)

        if let book = realm.object(ofType: Book.self, forPrimaryKey: bookURL.bookID) {
            return book
        }

        // No book exists, create new one
        let newBook = Book(urlString: bookURL.bookID)

        try realm.write {
            realm.add(newBook)
        }

        return newBook
    }
}

extension DefaultBookAnalyzerService: BookAnalyzerServiceProtocol {
    func analyze() -> AnyPublisher<Int, Error> {
        guard let bookStream = BookStreamer(path: bookURL.path) else {
            return Fail(outputType: Int.self, failure: PrimeWordsError.invalidFilePath(filePath: bookURL.path))
                .eraseToAnyPublisher()
        }

        // Retrieve or create Book object
        do {
            let bookToAnalyze = try book()
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                bookToAnalyze.reset()
            }
        } catch {
            return Fail(outputType: Int.self, failure: error).eraseToAnyPublisher()
        }

        var linesRead = 0

        return bookStream.readPublisher()
            .analyzeLine()
            .addToRealm(bookID: bookURL.bookID, realmConfiguration: realmConfiguration)
            .map { _ in
                linesRead += 1
                return linesRead
            }
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
