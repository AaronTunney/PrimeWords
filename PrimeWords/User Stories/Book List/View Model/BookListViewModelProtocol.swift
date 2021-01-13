//
//  BookListViewModelProtocol.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import Foundation

protocol BookListViewModelProtocol: ViewModelProtocol {
    var title: String { get }

    var booksCount: Int { get }

    func bookSummary(at index: Int) -> BookSummaryViewModelProtocol
    func getBooks()
}
