//
//  RootFlowController.swift
//  events
//
//  Created by halcyon on 12/11/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit
import FirebaseAuth

class RootFlowController {
    private weak var window: UIWindow?
    private var navigationController: UINavigationController
    private var authenticationFlowController: AuthenticationFlowController?
    private var mainFlowController: MainFlowController?
    private let requestFactory: RequestFactory = RequestFactoryImpl()

    init(window: UIWindow?) {
        self.window = window
        navigationController = UINavigationController()
        window?.rootViewController = navigationController
    }

    func start() {
        guard let token = KeychainManager.shared.token else {
            startLogin()
            return
        }

        if token.isEmpty {
            startLogin()
        } else {
            startMain()
        }
    }

    private func startLogin() {
        authenticationFlowController = AuthenticationFlowController(with: navigationController)
        authenticationFlowController?.requestFactory = requestFactory
        authenticationFlowController?.flowDelegate = self
        authenticationFlowController?.start(style: .custom({ presentedViewController in
            self.window?.rootViewController = presentedViewController
            self.navigationController = presentedViewController
        }))
    }

    private func startMain() {
        mainFlowController = MainFlowController(with: navigationController)
        mainFlowController?.flowDelegate = self
        mainFlowController?.start(style: .custom({ (presentedViewController) in
            self.window?.rootViewController = presentedViewController
            self.navigationController = presentedViewController
        }))
    }
}

extension RootFlowController: AuthenticationFlowDelegate {
    func didLogin() {
        startMain()
        authenticationFlowController = nil
    }
}

extension RootFlowController: MainFlowDelegate {
    func didLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
        KeychainManager.shared.set(nil, forKey: KeychainManager.tokenKey)
        startLogin()
        mainFlowController = nil
    }
}
