//
//  BookAnalyzerServiceProtocol.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation
import Combine

protocol BookAnalyzerServiceProtocol {
    func analyze() -> AnyPublisher<Int, Error>
}
