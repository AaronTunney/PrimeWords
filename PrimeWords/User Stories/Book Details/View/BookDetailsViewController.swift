//
//  BookDetailsViewController.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 14/01/2021.
//

import UIKit

class BookDetailsViewController: UIViewController {
    private struct K {
        static let cellName = "Word"
    }

    var viewModel: BookDetailsViewModelProtocol!
    var router: BookDetailsWireframeProtocol?

    private var tableView: UITableView!
    private var progressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        viewModel.viewModelDidChange = { [weak self] result in
            switch result {
            case .success(let viewModel):
                if let bookDetailsViewModel = viewModel as? BookDetailsViewModelProtocol {
                    self?.configure(viewModel: bookDetailsViewModel)
                }
                self?.tableView?.reloadData()
            case .failure(let error):
                os_log(error: error, log: .bookList)
            }
        }

        viewModel.analyzeBook()
    }

    private func setupViews() {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        self.tableView = tableView

        let progressLabel = UILabel()
        progressLabel.adjustsFontForContentSizeCategory = true
        progressLabel.font = .preferredFont(forTextStyle: .title1)
        progressLabel.textAlignment = .center
        progressLabel.textColor = .secondaryLabel
        progressLabel.backgroundColor = .secondarySystemBackground

        view.addSubview(progressLabel)
        self.progressLabel = progressLabel

        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Layout:
        // [Table View]
        // [Progress Label]
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),

            progressLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            progressLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            progressLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(WordSummaryTableViewCell.self, forCellReuseIdentifier: K.cellName)
    }

    private func configure(viewModel: BookDetailsViewModelProtocol) {
        print("+++ \(viewModel.progressText ?? "no text")")
        progressLabel.text = viewModel.progressText
    }
}

// MARK: - Table View data source

extension BookDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.wordCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath) as? WordSummaryTableViewCell else {
            fatalError("Unable to dequeue reuseable cell")
        }

        cell.configure(viewModel: viewModel.wordSummary(at: indexPath.row))

        return cell
    }
}

// MARK: - Table View delegate

extension BookDetailsViewController: UITableViewDelegate {}

// MARK: - Books Detail view protocol

extension BookDetailsViewController: BookDetailsViewProtocol {}
