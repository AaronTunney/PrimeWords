//
//  BookListViewModelProtocol.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import Foundation
import Combine

protocol BookListViewModelProtocol: ObservableObject {
    var title: String { get }
    var booksCount: Int { get }

    func bookSummary(at index: Int) -> BookSummaryViewModelProtocol

    func getBooks()
    func bookSelected(at row: Int, router: BookListWireframeProtocol)
}
