//
//  BookSummaryTableViewCell.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import UIKit

class BookSummaryTableViewCell: UITableViewCell {
    func configure(viewModel: BookSummaryViewModelProtocol) {
        textLabel?.text = viewModel.title
        imageView?.image = UIImage(systemName: viewModel.iconName)
    }
}
