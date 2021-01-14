//
//  LocalBooksService.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import Foundation
import Combine
import os.log

class LocalBooksService: BooksServiceProtocol {
    private struct K {
        static let textFileExt = "txt"
    }

    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func getBookURLs() -> AnyPublisher<[URL], Error> {
        let fileURLs = bundle.paths(forResourcesOfType: K.textFileExt, inDirectory: nil)
            .map { URL(fileURLWithPath: $0) }

        os_log("Found %{public}td books", log: .booksService, type: .debug, fileURLs.count)

        return Just(fileURLs)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
