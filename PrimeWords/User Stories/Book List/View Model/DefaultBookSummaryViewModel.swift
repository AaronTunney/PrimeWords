//
//  DefaultBookSummaryViewModel.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 13/01/2021.
//

import Foundation

class DefaultBookSummaryViewModel {
    let title: String
    let iconName = "book"

    init(model: URL) {
        self.title = model.lastPathComponent
    }
}

extension DefaultBookSummaryViewModel: BookSummaryViewModelProtocol {}
