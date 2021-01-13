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

        let mainVC = UIViewController()
        mainVC.view.backgroundColor = .yellow
        let detailVC = UIViewController()
        detailVC.view.backgroundColor = .red

        view.viewControllers = [mainVC, detailVC]

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
