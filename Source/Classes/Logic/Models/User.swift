//
//  User.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

struct User: Codable {
    let kind: String
    let idToken: String
    let email: String
    let refreshToken: String
    let expiresIn: String
    let localId: String
}
