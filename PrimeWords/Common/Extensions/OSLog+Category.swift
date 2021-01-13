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
    static let fileList = OSLog(subsystem: subsystem, category: "file list")
    static let results = OSLog(subsystem: subsystem, category: "results")
    static let bookAnalyzer = OSLog(subsystem: subsystem, category: "book analyzer")
    static let test = OSLog(subsystem: subsystem, category: "test")
}

func os_log(error: Error, log: OSLog) {
    os_log("%{public}@", log: log, type: .error, error.localizedDescription)
}
