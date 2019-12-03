//
//  MainFlowController.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

protocol MainFlowDelegate: class {
    func didLogOut()
}

class MainFlowController: BaseFlowController {
    weak var flowDelegate: MainFlowDelegate?
    private var tabBarController: TabBarViewController!
    private var eventListFlowController: EventListFlowController!
    private var myEventsFlowController: MyEventsFlowController!
    private var addEventFLowController: AddEventFlowController!
    private var favouriteService: FavouriteEventService = FavouriteEventServiceImpl()
    private let viewCFactory: ViewControllerFactory = ViewControllerFactoryImpl()

    override func start(style: PresentationStyle) {
        rootViewController = setupTabBarController()
        super.start(style: style)
    }

    override func finish() {
        flowDelegate?.didLogOut()
    }

    private func setupTabBarController() -> TabBarViewController {
        tabBarController = TabBarViewController()
        tabBarController.flowDelegate = self

        eventListFlowController = EventListFlowController(with: UINavigationController())
        eventListFlowController.favouriteService = favouriteService
        eventListFlowController.viewControllerFactory = viewCFactory
        eventListFlowController.flowDelegate = self
        eventListFlowController.start(style: .push)
        eventListFlowController.rootViewController.tabBarItem = UITabBarItem(title: Strings.events, image: #imageLiteral(resourceName: "icon_calendar"), selectedImage: #imageLiteral(resourceName: "icon_calendar"))

        addEventFLowController = AddEventFlowController(with: UINavigationController())
        addEventFLowController.flowDelegate = self
        addEventFLowController.viewControllerFactory = viewCFactory
        addEventFLowController.start()
        let fakeView = UIViewController()
        fakeView.tabBarItem.isEnabled = false

        myEventsFlowController = MyEventsFlowController(with: UINavigationController())
        myEventsFlowController.favouriteService = favouriteService
        myEventsFlowController.viewControllerFactory = viewCFactory
        myEventsFlowController.start(style: .push)
        myEventsFlowController.rootViewController.tabBarItem = UITabBarItem(title: Strings.myEvents, image: #imageLiteral(resourceName: "icon_compose"), selectedImage: #imageLiteral(resourceName: "icon_compose"))

        tabBarController.viewControllers = [eventListFlowController.navigationController, fakeView, myEventsFlowController.navigationController]

        return tabBarController
    }
}

extension MainFlowController: EventListFlowDelegate {
    func didFinish() {
        flowDelegate?.didLogOut()
    }
}

extension MainFlowController: TabBarViewControllerDelegate {
    func addButtonTapped(on viewController: TabBarViewController) {
        guard let addEventView = addEventFLowController.rootViewController else { return }
        addEventView.modalPresentationStyle = .overCurrentContext
        viewController.present(addEventView, animated: true)
    }
}

extension MainFlowController: AddEventFlowDelegate {
    func didFinishAddEvent(viewController: AddEventViewController) {
        UIView.animate(withDuration: 0.4) {
            viewController.dismiss(animated: true)
        }
    }
}
