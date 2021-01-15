//
//  DefaultBookDetailsViewModel.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 14/01/2021.
//

import Foundation
import Combine
import os.log
import RealmSwift

class DefaultBookDetailsViewModel {
    weak var view: BookDetailsViewProtocol?

    @Published var isLoading = true

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
        isLoading = true

        bookAnalyzer.analyze()
            .sink { [weak self] complete in
                switch complete {
                case .failure(let error):
                    os_log(error: error, log: .bookDetails)
                    self?.isLoading = false
                case .finished:
                    guard let strongSelf = self else { return }
                    strongSelf.words = strongSelf.bookAnalyzer.book?.words.sorted(byKeyPath: #keyPath(Word.count), ascending: false)
                    strongSelf.isLoading = false
                }
            } receiveValue: { _ in
            }
            .store(in: &disposables)
    }

}
