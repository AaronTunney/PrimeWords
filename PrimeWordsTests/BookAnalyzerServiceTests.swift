//
//  BookAnalyzerServiceTests.swift
//  PrimeWordsTests
//
//  Created by Aaron Tunney on 14/01/2021.
//

import XCTest
import RealmSwift
import Combine
@testable import PrimeWords

class BookAnalyzerServiceTests: XCTestCase {
    private struct K {
        static let defaultTimeout: TimeInterval = 15
        static let largeTimeout: TimeInterval = 720
    }

    private enum File: String {
        case emptyBook
        case singleLineBook
        case multiLineBook
        case punctuatedBook
        case completeBook
    }

    private var disposables = Set<AnyCancellable>()

    // MARK: - Successful tests

    func testEmptyBook() throws {
        try runBookTest(file: .emptyBook)
    }

    func testSingleLineBook() throws {
        try runBookTest(file: .singleLineBook)
    }

    func testMultiLineBook() throws {
        try runBookTest(file: .multiLineBook)
    }

    func testPunctuatedBook() throws {
        try runBookTest(file: .punctuatedBook)
    }

    // MARK: - Performance tests

    func testAnalyzerPerformance() throws {
        let fileURL = try XCTUnwrap(url(for: .completeBook))

        let realmConfiguration = generateRealmConfiguration()
        let bookAnalyzer = DefaultBookAnalyzerService(url: fileURL, realmConfiguration: realmConfiguration)

        self.measure {
            let bookExpectation = expectation(description: #function)

            bookAnalyzer.analyze()
                .sink { complete in
                    switch complete {
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    case .finished:
                        bookExpectation.fulfill()
                    }
                } receiveValue: { _ in }
                .store(in: &disposables)

            wait(for: [bookExpectation], timeout: K.largeTimeout)
        }
    }

    // MARK: - Test helpers

    private func runBookTest(file: File) throws {
        let fileURL = try XCTUnwrap(url(for: file))

        let realmConfiguration = generateRealmConfiguration()
        let bookAnalyzer = DefaultBookAnalyzerService(url: fileURL, realmConfiguration: realmConfiguration)

        let bookExpectation = expectation(description: file.rawValue)

        bookAnalyzer.analyze()
            .sink { complete in
                switch complete {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    bookExpectation.fulfill()
                }
            } receiveValue: { value in
                print("Lines read: \(value)")
            }
            .store(in: &disposables)

        wait(for: [bookExpectation], timeout: K.defaultTimeout)

        let realm = try Realm(configuration: realmConfiguration)
        let book = try XCTUnwrap(realm.object(ofType: Book.self, forPrimaryKey: fileURL.bookID))

        evaluteBook(book)
    }
    
    private func evaluteBook(_ book: Book) {
        book.words.forEach { word in
            switch word.name {
            case "one":
                XCTAssertEqual(word.count, 1)
            case "two":
                XCTAssertEqual(word.count, 2)
            case "three":
                XCTAssertEqual(word.count, 3)
            case "four":
                XCTAssertEqual(word.count, 4)
            case "five":
                XCTAssertEqual(word.count, 5)
            default:
                XCTFail("\(word.name) has count \(word.count)")
            }
        }
    }

    // MARK: - Utility helpers

    private func generateRealmConfiguration() -> Realm.Configuration {
        return Realm.Configuration(inMemoryIdentifier: UUID().uuidString)
    }

    private func url(for file: File) -> URL? {
        guard let path = Bundle(for: type(of: self)).path(forResource: file.rawValue, ofType: "txt") else {
            return nil
        }

        return URL(fileURLWithPath: path)
    }
}
