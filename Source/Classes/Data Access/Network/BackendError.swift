//
//  BackenError.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Foundation
import Firebase

enum BackendError: Error {
    case invalidJSON
    case invalidURL
    case invalidData
    case generalError

    var message: String {
        switch self {
        case .invalidJSON:
            return "Invalid JSON!"
        case .invalidURL:
            return "Invalid URL!"
        case .invalidData:
            return "Problem with data!"
        case .generalError:
            return "Sorry, something went wrong!"
        }
    }
}

func FirebaseError(errCode: Int) -> String {
    if let errorCode = AuthErrorCode(rawValue: errCode) {
        switch errorCode {
        case .emailAlreadyInUse:
            return "Email already used!"
        case .invalidEmail:
            return "Invalid email"
        case .weakPassword:
            return "Weak password (at least 6 character)"
        case .wrongPassword:
            return "Wrong password!"
        case .userNotFound:
            return "User not found!"
        default:
            return "Create user error!"
        }
    }
    return BackendError.generalError.message
}
