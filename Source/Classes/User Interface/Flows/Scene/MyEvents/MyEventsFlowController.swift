//
//  MyEventsFlowController.swift
//  events
//
//  Created by halcyon on 12/14/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

class MyEventsFlowController: BaseFlowController {
    var favouriteService: FavouriteEventService!
    var viewControllerFactory: ViewControllerFactory!
    
    override func start(style: PresentationStyle) {
        guard let myEventsViewController = viewControllerFactory.getViewC(type: .eventListV, eventType: .myEvents) as? EventListViewController else { return }
        myEventsViewController.viewModel = makeEventListViewModel()
        rootViewController = myEventsViewController
        super.start(style: style)
    }

    private func makeEventListViewModel() -> EventListViewModel {
        let viewModel = EventListViewModelImpl(service: favouriteService)
        viewModel.flowDelegate = self
        return viewModel
    }
}

extension MyEventsFlowController: EventListViewModelFlowDelegate {
    func shouldChangeToFavouritesView(service: FavouriteEventService) {
        guard let favouriteEvents = viewControllerFactory.getViewC(type: .favouritesV, eventType: nil) as? FavouriteEventViewController else { return }
        favouriteEvents.viewModel = makeFavouriteEventViewModel(service: service)
        favouriteEvents.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(favouriteEvents, animated: true)
    }

    private func makeFavouriteEventViewModel(service: FavouriteEventService) -> FavouriteEventViewModel {
        let viewModel = FavouriteEventViewModelImpl(service: service)
        return viewModel
    }

    func didLogOut() {}
    func didPresentSetThemeVC() {}
}
