//
//  BaseFlowController.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Foundation
import UIKit

enum PresentationStyle {
    case push, present, custom((UINavigationController) -> Void)
}

protocol FlowControllerDelegate: class {
    func didFinish(on flowController: BaseFlowController)
}

class BaseFlowController {
    private(set) var navigationController: UINavigationController

    var rootViewController: UIViewController!
    weak var delegate: FlowControllerDelegate?

    init (with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(style: PresentationStyle = .push) {
        guard let rootViewController = rootViewController else {
            assertionFailure("Set rootViewController!")
            return
        }

        switch style {
        case .push:
            navigationController.pushViewController(rootViewController, animated: true)
        case .present:
            let navController = UINavigationController(rootViewController: rootViewController)
            navigationController.present(navController, animated: true)
        case .custom(let completionBlock):
            navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.navigationBar.isHidden = true
            completionBlock(navigationController)
        }
    }

    func finish() {
        delegate?.didFinish(on: self)
    }
}
