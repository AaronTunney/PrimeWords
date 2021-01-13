//
//  Book.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 13/01/2021.
//

import Foundation
import RealmSwift

@objcMembers
class Book: Object {
    dynamic var urlString: String = ""
    let words = List<Word>()

    override class func primaryKey() -> String? {
        return #keyPath(urlString)
    }
}

@objcMembers
class Word: Object {
    dynamic var name: String = ""
    dynamic var count: Int = 0
    dynamic var isPrime: Bool?
}
