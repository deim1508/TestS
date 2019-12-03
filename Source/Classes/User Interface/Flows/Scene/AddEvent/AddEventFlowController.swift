//
//  AddEventFlowController.swift
//  events
//
//  Created by halcyon on 1/7/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

protocol AddEventFlowDelegate: class {
    func didFinishAddEvent(viewController: AddEventViewController)
}

class AddEventFlowController: BaseFlowController {
    weak var flowDelegate: AddEventFlowDelegate?
    var viewControllerFactory: ViewControllerFactory!
    private var addEventNavigatonController: UINavigationController?

    func start() {
        guard let addEventVC = viewControllerFactory.getViewC(type: .addEventV, eventType: nil) as? AddEventViewController else { return }
        addEventVC.viewModel = makeAddEventViewModel()
        addEventNavigatonController = UINavigationController(rootViewController: addEventVC)
        rootViewController = addEventNavigatonController
    }

    private func makeAddEventViewModel() -> AddEventViewModel {
        let viewModel = AddEventViewModelImpl()
        viewModel.flowDelegate = self
        return viewModel
    }
}

extension AddEventFlowController: AddEventViewModelFlowDelegate {
    func showMissingLocationAlert() {
        let alert = UIAlertController(title: "Error", message: Strings.missingData , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        addEventNavigatonController?.present(alert, animated: true)
    }
    
    func dismiss(_ viewController: AddEventViewController) {
        flowDelegate?.didFinishAddEvent(viewController: viewController)
    }
    func didCreatedBaseEvent(event: Event) {
        guard let setEventDetailVC = viewControllerFactory.getViewC(type: .setEventDetailV, eventType: nil) as? SetEventDetailViewController else { return }
        setEventDetailVC.viewModel = makeSetEventViewModel(event: event)
        addEventNavigatonController?.present(setEventDetailVC, animated: true)
    }

    private func makeSetEventViewModel(event: Event) -> SetEventDetailViewModel {
        let viewModel = SetEventDetailViewModelImpl(event: event)
        viewModel.flowDelegate = self
        return viewModel
    }
}

extension AddEventFlowController: SetEventDetailViewModelFlowDelegate {
    func showMissingDataAlert(on viewController: SetEventDetailViewController) {
        let alert = UIAlertController(title: "Error", message: Strings.missingData , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    func didFinish(_ viewController: SetEventDetailViewController) {
        addEventNavigatonController?.dismiss(animated: true)
        viewController.dismiss(animated: true) {
        }
    }
}
