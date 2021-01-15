//
//  BookAnalyzerServiceProtocol.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation
import Combine
import RealmSwift

protocol BookAnalyzerServiceProtocol {
    var book: Book? { get }

    func analyze() -> AnyPublisher<ThreadSafeReference<Book>, Error>
}
