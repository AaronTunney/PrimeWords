//
//  DefaultWordSummaryViewModel.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation

class DefaultWordSummaryViewModel: WordSummaryViewModelProtocol {
    let title: String
    let count: String
    let primeNumberIconName = "checkmark.seal"

    let showPrimeNumberLabel: Bool

    init(model: Word) {
        self.title = model.name.capitalized
        self.count = String(model.count)
        self.showPrimeNumberLabel = model.isPrime
    }
}
