//
//  BookDetailsViewModelProtocol.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 14/01/2021.
//

import Foundation
import Combine

protocol BookDetailsViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var wordCount: Int { get }

    func wordSummary(at index: Int) -> WordSummaryViewModelProtocol

    // Actions
    func analyzeBook()
}
