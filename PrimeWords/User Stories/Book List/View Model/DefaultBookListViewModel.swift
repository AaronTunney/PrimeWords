//
//  DefaultBookListViewModel.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import Foundation
import Combine
import os.log

class DefaultBookListViewModel {
    weak var view: BookListViewProtocol?
    var viewModelDidChange: ViewModelDidChangeBinding?

    let title: String = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }()

    private var bookURLs = [URL]()
    private let booksService: BooksServiceProtocol

    private var disposables = Set<AnyCancellable>()

    init(booksService: BooksServiceProtocol) {
        self.booksService = booksService
    }
}

extension DefaultBookListViewModel: BookListViewModelProtocol {
    var booksCount: Int {
        return bookURLs.count
    }

    func bookSummary(at index: Int) -> BookSummaryViewModelProtocol {
        return DefaultBookSummaryViewModel(model: bookURLs[index])
    }

    func getBooks() {
        booksService.getBookURLs()
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { complete in
                switch complete {
                case .failure(let error):
                    os_log(error: error, log: .bookList)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] output in
                self?.bookURLs = output.flatMap { $0 }

                guard let strongSelf = self else { return }
                self?.viewModelDidChange?(.success(strongSelf))
            }
            .store(in: &disposables)
    }

    func bookSelected(at row: Int, router: BookListWireframeProtocol) {
        let bookURL = bookURLs[row]
        let bookAnalyzer = DefaultBookAnalyzerService(url: bookURL)

        router.showBookDetailViewController(bookAnalyzer: bookAnalyzer)
    }
}
