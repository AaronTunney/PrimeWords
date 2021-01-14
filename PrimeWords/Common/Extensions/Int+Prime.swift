//
//  Int+Prime.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation

extension Int {
    // Taken from: https://stackoverflow.com/questions/31105664/check-if-a-number-is-prime
    //
    // The top five answers were benchmarked and the one that (a) passed all of the unit tests and
    // (b) performed the best was chosen.
    //
    // Ultimately a hard-coded list of primes would be the fastest solution here but that feels like
    // cheating!
    var isPrime: Bool {
        if self == 2 || self == 3 { return true }
        let maxDivider = Int(sqrt(Double(self)))
        return self > 1 && !(2...maxDivider).contains { self % $0 == 0 }
    }
}
