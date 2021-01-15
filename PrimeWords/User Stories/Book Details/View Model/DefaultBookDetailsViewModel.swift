//
//  DefaultBookDetailsViewModel.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation
import Combine
import os.log
import RealmSwift

class DefaultBookDetailsViewModel {
    weak var view: BookDetailsViewProtocol?

    @Published var isLoading = true
    var title = NSLocalizedString("PrimeWords.BookDetails.Title", comment: "Results")

    var wordCount: Int {
        words?.count ?? 0
    }

    private var words: Results<Word>?

    private let bookAnalyzer: BookAnalyzerServiceProtocol
    private var disposables = Set<AnyCancellable>()

    init(bookAnalyzer: BookAnalyzerServiceProtocol) {
        self.bookAnalyzer = bookAnalyzer
    }
}

extension DefaultBookDetailsViewModel: BookDetailsViewModelProtocol {
    func wordSummary(at index: Int) -> WordSummaryViewModelProtocol {
        guard let word = words?[index] else {
            fatalError("Incorrect usage")
        }

        return DefaultWordSummaryViewModel(model: word)
    }

    func analyzeBook() {
        // Take cached answer is available
        if let book = bookAnalyzer.book {
            finishAnalysis(book: book)
            return
        }

        isLoading = true

        bookAnalyzer.analyze()
            .sink { [weak self] complete in
                switch complete {
                case .failure(let error):
                    os_log(error: error, log: .bookDetails)
                    self?.isLoading = false
                case .finished:
                    guard let book = self?.bookAnalyzer.book else { return }
                    self?.finishAnalysis(book: book)
                }
            } receiveValue: { _ in
            }
            .store(in: &disposables)
    }

    private func finishAnalysis(book: Book) {
        words = book.words.sorted(byKeyPath: #keyPath(Word.count), ascending: false)
        isLoading = false
    }
}
