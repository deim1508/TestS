//
//  KeychainManager.swift
//  events
//
//  Created by halcyon on 12/13/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import SwiftKeychainWrapper

class KeychainManager {
    static let tokenKey = "token"
    public static let standard = KeychainWrapper.standard
    public static let shared = KeychainManager()
    var token: String? {
        get { return KeychainManager.standard.string(forKey: KeychainManager.tokenKey) }
        set { set(token, forKey: KeychainManager.tokenKey, withAccessibility: nil) }
    }

    @discardableResult func set(_ value: String?, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
        if let token = value {
            return KeychainManager.standard.set(token, forKey: key, withAccessibility: accessibility)
        } else {
            //If token == nil, remove
            KeychainManager.shared.removeToken()
            return false
        }
    }

    private func removeToken() {
        KeychainManager.standard.removeObject(forKey: KeychainManager.tokenKey)
    }
}
