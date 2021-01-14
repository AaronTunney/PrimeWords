//
//  Word.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 14/01/2021.
//

import Foundation
import RealmSwift

@objcMembers
class Word: Object {
    dynamic var name: String = ""
    dynamic var count: Int = 0
    dynamic var isPrime: Bool?

    convenience init(name: String, count: Int) {
        self.init()

        self.name = name
        self.count = count
    }
}
