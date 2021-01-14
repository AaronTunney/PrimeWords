//
//  WordSummaryTableViewCell.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 14/01/2021.
//

import UIKit

class WordSummaryTableViewCell: UITableViewCell {
    private struct K {
        static let margin: CGFloat = 8
        static let iconWidth: CGFloat = 34
    }

    private var titleLabel: UILabel!
    private var countLabel: UILabel!
    private var primeIconView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let titleLabel = UILabel()
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label

        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel

        let countLabel = UILabel()
        countLabel.adjustsFontForContentSizeCategory = true
        countLabel.font = .preferredFont(forTextStyle: .body)
        countLabel.textColor = .secondaryLabel
        countLabel.textAlignment = .right

        contentView.addSubview(countLabel)
        self.countLabel = countLabel

        let primeIconView = UIImageView()
        primeIconView.contentMode = .scaleAspectFit

        contentView.addSubview(primeIconView)
        self.primeIconView = primeIconView

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        primeIconView.translatesAutoresizingMaskIntoConstraints = false

        // Layout:
        // [Icon] [Title] <-> [Count]
        NSLayoutConstraint.activate([
            primeIconView.heightAnchor.constraint(equalToConstant: K.iconWidth),
            primeIconView.widthAnchor.constraint(equalToConstant: K.iconWidth),
            primeIconView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            primeIconView.topAnchor.constraint(equalTo: titleLabel.topAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: primeIconView.leadingAnchor, constant: K.margin),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),

            countLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: K.margin),
            countLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            countLabel.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor),
            countLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }

    func configure(viewModel: WordSummaryViewModelProtocol) {
        titleLabel?.text = viewModel.title
        countLabel.text = viewModel.count
    }
}
