//
//  DefaultBookDetailsViewModel.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 14/01/2021.
//

import Foundation
import Combine
import os.log

class DefaultBookDetailsViewModel {
    weak var view: BookDetailsViewProtocol?
    var viewModelDidChange: ViewModelDidChangeBinding?

    var progressText: String?
    private var book: Book? {
        bookAnalyzer.book
    }

    private let bookAnalyzer: BookAnalyzerServiceProtocol
    private var disposables = Set<AnyCancellable>()

    init(bookAnalyzer: BookAnalyzerServiceProtocol) {
        self.bookAnalyzer = bookAnalyzer
    }
}

extension DefaultBookDetailsViewModel: BookDetailsViewModelProtocol {
    var wordCount: Int {
        book?.words.count ?? 0
    }

    func wordSummary(at index: Int) -> WordSummaryViewModelProtocol {
        guard let word = book?.words[index] else {
            fatalError("Incorrect usage")
        }

        return DefaultWordSummaryViewModel(model: word)
    }

    func analyzeBook() {
        bookAnalyzer.analyze()
            .sink { [weak self] complete in
                switch complete {
                case .failure(let error):
                    os_log(error: error, log: .bookDetails)
                case .finished:
                    self?.progressText = NSLocalizedString("PrimeWords.BookDetails.Progress.Complete", comment: "Analysis Complete!")
                    guard let strongSelf = self else { return }
                    self?.viewModelDidChange?(.success(strongSelf))
                }
            } receiveValue: { [weak self] response in
                let format = NSLocalizedString("PrimeWords.BookDetails.Progress.Title", comment: "X lines processed")
                self?.progressText = String(format: format, response)
                guard let strongSelf = self else { return }
                self?.viewModelDidChange?(.success(strongSelf))
            }
            .store(in: &disposables)
    }

}
