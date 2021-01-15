//
//  BookDetailsViewController.swift
//  PrimeWords
//
//  Created by Tunney, Aaron (ELS) on 14/01/2021.
//

import UIKit
import Combine
import os.log

class BookDetailsViewController: UIViewController {
    private struct K {
        enum Cell: String {
            case word
            case loading
        }

        static let loadingRowsCount = 1
    }

    // One of the downsides of Combine is that its publish/observe model
    // is based on property wrappers and therefore incompatible with
    // protocols.
    var viewModel: DefaultBookDetailsViewModel!
    var router: BookDetailsWireframeProtocol?

    private var tableView: UITableView!
    private var loadingSpinner: UIActivityIndicatorView!

    private var disposables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()

        viewModel.analyzeBook()
    }

    private func setupViews() {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        self.tableView = tableView

        let loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.hidesWhenStopped = true

        view.addSubview(loadingSpinner)
        self.loadingSpinner = loadingSpinner

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(WordSummaryTableViewCell.self, forCellReuseIdentifier: K.Cell.word.rawValue)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: K.Cell.loading.rawValue)
    }

    private func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                os_log("Words loading: %{public}td", log: .bookDetails, type: .debug, isLoading)
                self?.tableView.reloadData()
            })
            .store(in: &disposables)
    }
}

// MARK: - Table View data source

extension BookDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isLoading {
            return K.loadingRowsCount
        }

        return viewModel.wordCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isLoading {
            return loadingCell(for: tableView, indexPath: indexPath)
        }

        return wordCell(for: tableView, indexPath: indexPath)
    }

    private func wordCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.word.rawValue, for: indexPath) as? WordSummaryTableViewCell else {
            fatalError("Unable to dequeue reuseable cell")
        }

        cell.configure(viewModel: viewModel.wordSummary(at: indexPath.row))

        return cell
    }

    private func loadingCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.loading.rawValue, for: indexPath) as? LoadingTableViewCell else {
            fatalError("Unable to dequeue reuseable cell")
        }

        return cell
    }
}

// MARK: - Table View delegate

extension BookDetailsViewController: UITableViewDelegate {}

// MARK: - Books Detail view protocol

extension BookDetailsViewController: BookDetailsViewProtocol {}
