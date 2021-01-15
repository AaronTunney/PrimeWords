//
//  WordSummaryViewModelProtocol.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation

protocol WordSummaryViewModelProtocol {
    var title: String { get }
    var count: String { get }
    var primeNumberIconName: String { get }

    var showPrimeNumberLabel: Bool { get }
}
