//
//  BooksServiceProtocol.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import Foundation
import Combine

protocol BooksServiceProtocol {
    // Using a publisher here is overkill for retrieving a local list of
    // books but this protocol could also be implemented by a network-based
    // implementation.
    func getBookURLs() -> AnyPublisher<[URL], Error>
}
