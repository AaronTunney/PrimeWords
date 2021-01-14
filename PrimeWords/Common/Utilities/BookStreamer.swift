//
//  BookStreamer.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation
import Combine

// Modified from the solution here: https://stackoverflow.com/questions/43238966/swift-version-of-streamreader-only-streams-the-entire-file-not-in-chunks-which
//
class BookStreamer {
    private let file: UnsafeMutablePointer<FILE>!

    init?(path: String) {
        guard let file = fopen(path, "r") else { return nil }

        self.file = file
    }

    deinit {
        fclose(file)
    }

    func readPublisher(dispatchQueue: DispatchQueue = .global(qos: .utility)) -> AnyPublisher<String, Never> {
        let publisher = PassthroughSubject<String, Never>()

        dispatchQueue.async {
            self.forEach { publisher.send($0) }
            publisher.send(completion: .finished)
        }

        return publisher.eraseToAnyPublisher()
    }

    private func nextLine() -> String? {
        var line: UnsafeMutablePointer<CChar>?
        var linecap: Int = 0
        defer { free(line) }
        // The check has already been made so force unwrapping is fine here
        // swiftlint:disable force_unwrapping
        return getline(&line, &linecap, file) > 0 ? String(cString: line!) : nil
        // swiftlint:enable force_unwrapping
    }
}

extension BookStreamer: Sequence {
    func makeIterator() -> AnyIterator<String> {
        return AnyIterator<String> {
            return self.nextLine()
        }
    }
}
