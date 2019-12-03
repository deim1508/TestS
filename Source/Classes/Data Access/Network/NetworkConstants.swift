//
//  NetworkConstants.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Foundation

struct NetworkConstans {
    struct ProductionServer {
        static let baseURL = "https://events-57d88.firebaseio.com/"
        static let authBaseURL = "https://www.googleapis.com/identitytoolkit/v3/relyingparty"
    }

    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let page = "page"
        static let perPage = "per_page"
        static let updated = "updated_at"
        static let shopId = "shop_id"
        static let productId = "id"
        static let comment = "comment"
        static let returnSecureToken = "returnSecureToken"
        static let key = "key"
    }
}

enum HTTPHeaderField: String {
    case authentication = "token"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
    case APIKey = "AIzaSyC4Ly_rRe-8R9MHfoP8Q-dZHLrQ0GAjNTk"
}
