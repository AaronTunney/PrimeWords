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
    private struct K {
        static let defaultChunkSize = 500
    }

    var book: Book? {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            return realm.object(ofType: Book.self, forPrimaryKey: bookURL.bookID)
        } catch {
            os_log(error: error, log: .bookAnalyzer)
            return nil
        }
    }

    private let realmConfiguration: Realm.Configuration
    private let dispatchQueue: DispatchQueue
    private let bookURL: URL
    private let chunkSize: Int

    init(url: URL,
         chunkSize: Int = K.defaultChunkSize,
         realmConfiguration: Realm.Configuration = .defaultConfiguration,
         dispatchQueue: DispatchQueue = .global(qos: .utility)) {
        self.bookURL = url
        self.chunkSize = chunkSize
        self.realmConfiguration = realmConfiguration
        self.dispatchQueue = dispatchQueue
    }

    private func createBook() throws -> Book {
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
    func analyze() -> AnyPublisher<ThreadSafeReference<Book>, Error> {
        guard let bookStream = BookStreamer(path: bookURL.path) else {
            return Fail(outputType: ThreadSafeReference<Book>.self, failure: PrimeWordsError.invalidFilePath(filePath: bookURL.path))
                .eraseToAnyPublisher()
        }

        // Retrieve or create Book object
        do {
            let bookToAnalyze = try createBook()
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                bookToAnalyze.reset()
            }
        } catch {
            return Fail(outputType: ThreadSafeReference<Book>.self, failure: error).eraseToAnyPublisher()
        }

        return bookStream.readPublisher()
            .analyzeLine()
            .collect()
            .saveToRealm(bookID: bookURL.bookID, realmConfiguration: realmConfiguration)
            .map { ThreadSafeReference(to: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
