//
//  MVVMCommon.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import Foundation

typealias ViewModelDidChangeBinding = (Result<ViewModelProtocol, Error>) -> Void

protocol ViewModelProtocol {
    var viewModelDidChange: ViewModelDidChangeBinding? { get set }
}
