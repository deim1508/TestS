//
//  AuthenticationViewModel.swift
//  events
//
//  Created by halcyon on 12/11/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

protocol AuthenticationViewModel {
    var email: String { get set }
    var password: String { get set }

    func didTappedChangeLoginToSignup()
    func didTappedAuthenticationButton(completion: @escaping () -> Void)
    func getRandomImage() -> UIImage
}

protocol  AuthenticationViewModelFlowDelegate: class {
    func loginTapped(on viewModel: AuthenticationViewModel)
    func didTappedChangeToSignUpView()
    func showAuthenticationFailedAlert(message: String)
}

class AuthenticationViewModelImpl: AuthenticationViewModel {
    weak var flowDelegate: AuthenticationViewModelFlowDelegate?
    var email: String = ""
    var password: String = ""
    private let type: AuthenticationType
    private let authService: AuthenticationService
    private let images = [#imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "8")]

    init(service: AuthenticationService, type: AuthenticationType) {
        authService = service
        self.type = type
    }

    func getRandomImage() -> UIImage {
        return images[Int(arc4random_uniform(UInt32(images.count)))]
    }

   func didTappedAuthenticationButton(completion: @escaping () -> Void = {}) {
        switch type {
        case .logIn:
            authService.signIn(email: email, password: password, succes: { _ in
                self.flowDelegate?.loginTapped(on: self)
            }, failure: { error in
                self.flowDelegate?.showAuthenticationFailedAlert(message: error)
                completion()
            })
        case .signUp:
            authService.signUp(email: email, password: password, succes: { _ in
                self.flowDelegate?.loginTapped(on: self)
            }, failure: { error in
                self.flowDelegate?.showAuthenticationFailedAlert(message: error)
                completion()
            })
        }
    }

    func didTappedChangeLoginToSignup() {
        self.flowDelegate?.didTappedChangeToSignUpView()
    }
}
