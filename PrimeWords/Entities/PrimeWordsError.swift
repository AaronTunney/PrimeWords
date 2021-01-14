//
//  PrimeWordsError.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation

enum PrimeWordsError: Error {
    case invalidFilePath(filePath: String)
}

extension PrimeWordsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidFilePath(let filePath):
            let format = NSLocalizedString("PrimeWords.Common.Error.invalidFilePath", comment: "Invalid file path")
            return String(format: format, filePath)
        }
    }
}
