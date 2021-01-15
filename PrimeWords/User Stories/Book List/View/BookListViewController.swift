//
//  BookListViewController.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import UIKit
import Combine

class BookListViewController: UIViewController {
    private struct K {
        static let cellName = "Book"
    }

    // One of the downsides of Combine is that its publish/observe model
    // is based on property wrappers and therefore incompatible with
    // protocols.
    var viewModel: DefaultBookListViewModel!
    var router: BookListWireframeProtocol?

    private var tableView: UITableView?
    private var disposables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()

        viewModel.getBooks()
    }

    private func setupViews() {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(BookSummaryTableViewCell.self, forCellReuseIdentifier: K.cellName)

        self.tableView = tableView
    }

    private func bindViewModel() {
        title = viewModel.title

        viewModel.$booksCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView?.reloadData()
            }
            .store(in: &disposables)
    }
}

// MARK: - Table View data source

extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.booksCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath) as? BookSummaryTableViewCell else {
            fatalError("Unable to dequeue reuseable cell")
        }

        cell.configure(viewModel: viewModel.bookSummary(at: indexPath.row))

        return cell
    }
}

// MARK: - Table View delegate

extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        guard let router = router else { return }

        viewModel.bookSelected(at: indexPath.row, router: router)
    }
}

// MARK: - Book List view protocol

extension BookListViewController: BookListViewProtocol {}
