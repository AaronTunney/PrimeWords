//
//  DefaultBookSummaryViewModel.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
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
