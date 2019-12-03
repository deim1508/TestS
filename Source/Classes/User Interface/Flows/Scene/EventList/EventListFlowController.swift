//
//  EventListFlowController.swift
//  events
//
//  Created by halcyon on 12/14/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

protocol EventListFlowDelegate: class {
    func didFinish()
}

class EventListFlowController: BaseFlowController {
    var favouriteService: FavouriteEventService!
    weak var flowDelegate: EventListFlowDelegate?
    var viewControllerFactory: ViewControllerFactory!

    override func start(style: PresentationStyle) {
        guard let eventListVC = viewControllerFactory.getViewC(type: .eventListV, eventType: .allEvent) as? EventListViewController else { return }
        eventListVC.viewModel = makeEventListViewModel()
        rootViewController = eventListVC
        super.start(style: style)
    }

    private func makeEventListViewModel() -> EventListViewModel {
        let viewModel = EventListViewModelImpl(service: favouriteService)
        viewModel.flowDelegate = self
        return viewModel
    }
}

extension EventListFlowController: EventListViewModelFlowDelegate {
    func shouldChangeToFavouritesView(service: FavouriteEventService) {}
    func didLogOut() {
        flowDelegate?.didFinish()
    }

    func didPresentSetThemeVC() {
        let setThemeVC = SetThemeViewController()
        setThemeVC.viewModel = makeSetThemeViewModel()
        navigationController.present(setThemeVC, animated: true)
    }

    private func makeSetThemeViewModel() -> SetThemeViewModel {
        let viewModel = SetThemeViewModelImpl()
        viewModel.flowDelegate = self
        return viewModel
    }
}

extension EventListFlowController: SetThemeViewModelFlowDelegate {
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: Strings.generalError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
