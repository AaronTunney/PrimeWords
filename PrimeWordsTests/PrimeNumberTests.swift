//
//  PrimeNumberTests.swift
//  PrimeWordsTests
//
//  Created by Aaron Tunney on 14/01/2021.
//

import XCTest
@testable import PrimeWords

class PrimeNumberTests: XCTestCase {
    private struct K {
        static let firstPrimes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
        static let firstComposites = [0, 1, 4, 6, 8, 9, 10, 12, 14, 15]

        static let largePrime = 44_923_183
        static let largeComposite = 44_923_181
    }

    // MARK: - Successful tests

    func testFirstTenPrimes() {
        K.firstPrimes.forEach { number in
            let isPrime = number.isPrime
            printIsPrime(number: number, isPrime: isPrime)
            XCTAssertTrue(isPrime)
        }
    }

    func testFirstTenComposites() {
        K.firstComposites.forEach { number in
            let isPrime = number.isPrime
            printIsPrime(number: number, isPrime: isPrime)
            XCTAssertFalse(isPrime)
        }
    }

    // MARK: - Performance tests

    func testPerformancePrime() {
        let number = K.largePrime
        self.measure {
            let isPrime = number.isPrime
            printIsPrime(number: number, isPrime: isPrime)
            XCTAssertTrue(isPrime)
        }
    }

    func testPerformanceComposite() {
        let number = K.largeComposite
        self.measure {
            let isPrime = number.isPrime
            printIsPrime(number: number, isPrime: isPrime)
            XCTAssertFalse(isPrime)
        }
    }

    // MARK: - Helpers

    private func printIsPrime(number: Int, isPrime: Bool) {
        print("\(number) is \(isPrime ? "" : "not ")a prime")
    }
}
