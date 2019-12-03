//
//  AuthenticationFlowController.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

protocol AuthenticationFlowDelegate: class {
    func didLogin()
}

class AuthenticationFlowController: BaseFlowController {
    weak var flowDelegate: AuthenticationFlowDelegate?
    var requestFactory: RequestFactory!

    override func start(style: PresentationStyle) {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
        }
        let loginVC = AuthenticationViewController(type: .logIn)
        loginVC.viewModel = makeAuthenticationViewModel(of: .logIn)
        rootViewController = loginVC
        super.start(style: style)
    }

    private func makeAuthenticationViewModel(of type: AuthenticationType) -> AuthenticationViewModel {
        let viewModel = AuthenticationViewModelImpl(service: AuthenticationService(factory: requestFactory), type: type)
        viewModel.flowDelegate = self
        return viewModel
    }
}

extension AuthenticationFlowController: AuthenticationViewModelFlowDelegate {
    func loginTapped(on viewModel: AuthenticationViewModel) {
        flowDelegate?.didLogin()
    }

    func didTappedChangeToSignUpView() {
        let signupVC = AuthenticationViewController(type: .signUp)
        signupVC.viewModel = makeAuthenticationViewModel(of: .signUp)
        navigationController.pushViewController(signupVC, animated: true)
    }

    func showAuthenticationFailedAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}
