//
//  SigninRequest.swift
//  events
//
//  Created by halcyon on 12/14/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Alamofire
import Foundation

class SigninRequest: RequestRepresentable {
    var methodType: HTTPMethod
    var suffix: String
    var parameters: [String: Any]?
    var encoding: URLEncoding

    init(parameters: RequestParameters) {
        self.methodType = .post
        self.encoding = .queryString
        self.suffix = "/verifyPassword"
        guard let email = parameters.email, let password = parameters.password else { return }
        self.parameters = [NetworkConstans.APIParameterKey.key: ContentType.APIKey.rawValue, NetworkConstans.APIParameterKey.email: email, NetworkConstans.APIParameterKey.password: password, NetworkConstans.APIParameterKey.returnSecureToken: true]
    }
}
