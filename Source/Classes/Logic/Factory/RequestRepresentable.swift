//
//  RequestRepresentable.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Alamofire
import Foundation

protocol RequestRepresentable {
    var methodType: HTTPMethod { get }
    var suffix: String { get }
    var parameters: [String: Any]? { get }
    var encoding: URLEncoding { get }
}

extension RequestRepresentable {
    var parameters: [String: Any]? {
        return nil
    }

    var encoding: URLEncoding {
        switch methodType {
        case .get, .delete: return .queryString
        default: return .httpBody
        }
    }
}
