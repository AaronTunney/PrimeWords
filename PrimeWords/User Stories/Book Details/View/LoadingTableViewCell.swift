//
//  LoadingTableViewCell.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 15/01/2021.
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
        // An activity indicator would be more appropriate here
        textLabel?.text = "Loading..."
    }
}
