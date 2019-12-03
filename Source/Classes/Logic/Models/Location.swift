//
//  Location.swift
//  events
//
//  Created by halcyon on 1/8/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import Foundation
import Firebase

struct Location {
    let ref: DatabaseReference?
    let key: String
    let name: String
    let longitude: Double
    let latitude: Double

    init(ref: DatabaseReference? = nil, name: String, longitude: Double, latitude: Double, key: String = "") {
        self.ref = ref
        self.key = key
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let longitude = value["longitude"] as? Double,
            let latitude = value["latitude"] as? Double else {
                return nil
        }
        self.init(ref: snapshot.ref, name: name, longitude: longitude, latitude: latitude, key: snapshot.key)
    }

    func toAnyObject() -> Any {
        return [
            "name": name,
            "longitude": longitude,
            "latittude": latitude
        ]
    }
}
