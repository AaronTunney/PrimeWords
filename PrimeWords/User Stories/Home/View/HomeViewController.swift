//
//  HomeViewController.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import UIKit

class HomeViewController: UISplitViewController {
    var viewModel: HomeViewModelProtocol!
    var router: HomeWireframeProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        preferredDisplayMode = .allVisible
    }
}

// MARK: - Split View Controller delegate

extension HomeViewController: UISplitViewControllerDelegate {
    @available(iOS 14.0, *)
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        .primary
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}

// MARK: - Home View protocol

extension HomeViewController: HomeViewProtocol {}
