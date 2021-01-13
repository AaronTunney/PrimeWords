//
//  BookListViewController.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import UIKit

class BookListViewController: UIViewController {
    private struct K {
        static let cellName = "Book"
    }

    var viewModel: BookListViewModelProtocol!
    var router: BookListWireframeProtocol?

    private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        configure(viewModel: viewModel)

        // MARK: - View lifecycle

        viewModel.viewModelDidChange = { [weak self] result in
            switch result {
            case .success(let viewModel):
                if let bookListViewModel = viewModel as? BookListViewModelProtocol {
                    self?.configure(viewModel: bookListViewModel)
                }
                self?.tableView?.reloadData()
            case .failure(let error):
                os_log(error: error, log: .bookList)
            }
        }

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

    private func configure(viewModel: BookListViewModelProtocol) {
        title = viewModel.title
    }
}

// MARK: - Table View data source

extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.booksCount
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

extension BookListViewController: UITableViewDelegate {}

// MARK: - Book List view protocol

extension BookListViewController: BookListViewProtocol {}
