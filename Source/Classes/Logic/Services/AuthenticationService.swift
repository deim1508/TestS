//
//  AuthenticationService.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationService {
    private let requestFactory: RequestFactory

    init(factory: RequestFactory) {
        requestFactory = factory
    }

    func signUp(email: String, password: String, succes: @escaping(Bool) -> Void, failure: @escaping (String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                guard let user = result?.user else { return }
                KeychainManager.shared.set(user.uid, forKey: KeychainManager.tokenKey)
                succes(true)
            } else {
                guard let error = error as NSError? else { failure(Strings.generalError)
                    return
                }
                failure(FirebaseError(errCode: error.code))
            }
        }
    }

    func signIn(email: String, password: String, succes: @escaping(Bool) -> Void, failure: @escaping (String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                guard let user = result?.user else { return }
                KeychainManager.shared.set(user.uid, forKey: KeychainManager.tokenKey)
                succes(true)
            } else {
                guard let error = error as NSError? else { failure(Strings.generalError)
                    return
                }
                failure(FirebaseError(errCode: error.code))
            }
        }
    }
}
