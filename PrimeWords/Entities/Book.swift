//
//  Book.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import Foundation
import RealmSwift

@objcMembers
class Book: Object {
    dynamic var urlString: String = ""
    let words = List<Word>()

    convenience init(urlString: String) {
        self.init()
        self.urlString = urlString
    }

    func reset() {
        words.removeAll()
    }

    override class func primaryKey() -> String? {
        return #keyPath(urlString)
    }
}
