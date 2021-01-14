//
//  BookDetailsViewModelProtocol.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 14/01/2021.
//

import Foundation

protocol BookDetailsViewModelProtocol: ViewModelProtocol {
    var progressText: String? { get }

    var wordCount: Int { get }

    func wordSummary(at index: Int) -> WordSummaryViewModelProtocol

    // Actions
    func analyzeBook()
}
