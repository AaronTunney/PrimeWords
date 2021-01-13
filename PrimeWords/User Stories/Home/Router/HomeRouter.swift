//
//  HomeRouter.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import UIKit

class HomeRouter {
    weak var view: HomeViewProtocol?

    static func createModule() -> UIViewController? {
        let view = HomeViewController()

        guard let mainViewController = BookListRouter.createModule() else { return nil }
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        let detailViewController = UIViewController()
        detailViewController.view.backgroundColor = .red

        view.viewControllers = [mainNavigationController, detailViewController]

        let viewModel = DefaultHomeViewModel()
        viewModel.view = view
        view.viewModel = viewModel

        let router = HomeRouter()
        router.view = view
        view.router = router

        return view
    }
}

extension HomeRouter: HomeWireframeProtocol {}
