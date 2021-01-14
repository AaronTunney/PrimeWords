//
//  BookListRouter.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import UIKit

class BookListRouter {
    weak var view: (UIViewController & BookListViewProtocol)?

    static func createModule(booksService: BooksServiceProtocol = LocalBooksService()) -> UIViewController {
        let view = BookListViewController()

        let viewModel = DefaultBookListViewModel(booksService: booksService)
        viewModel.view = view
        view.viewModel = viewModel

        let router = BookListRouter()
        router.view = view
        view.router = router

        return view
    }
}

extension BookListRouter: BookListWireframeProtocol {
    func showBookDetailViewController(bookAnalyzer: BookAnalyzerServiceProtocol) {
        let bookDetailViewController = BookDetailsRouter.createModule(bookAnalyzer: bookAnalyzer)
        view?.splitViewController?.showDetailViewController(bookDetailViewController, sender: view)
    }
}
