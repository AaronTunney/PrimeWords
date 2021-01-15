//
//  LoadingTableViewCell.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 15/01/2021.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        textLabel?.text = "Loading..."
    }
}
