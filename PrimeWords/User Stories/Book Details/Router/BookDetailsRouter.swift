//
//  BookDetailsRouter.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 14/01/2021.
//

import UIKit

class BookDetailsRouter {
    weak var view: BookDetailsViewProtocol?

    static func createModule(bookAnalyzer: BookAnalyzerServiceProtocol) -> UIViewController {
        let view = BookDetailsViewController()

        let viewModel = DefaultBookDetailsViewModel(bookAnalyzer: bookAnalyzer)
        viewModel.view = view
        view.viewModel = viewModel

        let router = BookDetailsRouter()
        router.view = view
        view.router = router

        return view
    }
}

extension BookDetailsRouter: BookDetailsWireframeProtocol {}
