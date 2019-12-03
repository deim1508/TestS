//
//  ServiceFactory.swift
//  events
//
//  Created by halcyon on 12/18/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Foundation

enum RequestType {
    case signUp
    case signIn
}

protocol RequestFactory {
    func getRequest(type: RequestType, parameters: RequestParameters) -> RequestRepresentable
}

class RequestFactoryImpl: RequestFactory {
    func getRequest(type: RequestType, parameters: RequestParameters) -> RequestRepresentable {
        switch type {
        case .signUp:
            return SignupRequest(parameters: parameters)
        case .signIn:
            return SigninRequest(parameters: parameters)
        }
    }
}
