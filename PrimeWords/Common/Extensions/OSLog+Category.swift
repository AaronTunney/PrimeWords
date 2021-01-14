//
//  OSLog+Category.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import Foundation
import os.log

extension OSLog {
    // swiftlint:disable force_unwrapping
    private static var subsystem = Bundle.main.bundleIdentifier!
    // swiftlint:enable force_unwrapping

    static let general = OSLog(subsystem: subsystem, category: "general")
    static let home = OSLog(subsystem: subsystem, category: "home")
    static let bookList = OSLog(subsystem: subsystem, category: "book list")
    static let bookDetails = OSLog(subsystem: subsystem, category: "book details")
    static let booksService = OSLog(subsystem: subsystem, category: "books service")
    static let bookAnalyzer = OSLog(subsystem: subsystem, category: "book analyzer")
    static let test = OSLog(subsystem: subsystem, category: "test")
}

func os_log(error: Error, log: OSLog) {
    os_log("%{public}@", log: log, type: .error, error.localizedDescription)
}
