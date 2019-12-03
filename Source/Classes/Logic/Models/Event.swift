//
//  Event.swift
//  events
//
//  Created by halcyon on 1/9/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import Foundation
import Firebase

struct Event {
    let ref: DatabaseReference?
    let key: String
    let location: String
    let date: Int
    let name: String
    let addmission: String
    let description: String?
    let eventType: String
    let imageUrl: String?
    let addedByUser: String

    init(ref: DatabaseReference? = nil, key: String = "", location: String, date: Int, name: String = "", addmission: String = "0", description: String? = "", eventType: String = "None", imageUrl: String? = "", addedByUser: String = "") {
        self.ref = ref
        self.key = key
        self.location = location
        self.date = date
        self.name = name
        self.addmission = addmission
        self.description = description
        self.eventType = eventType
        self.imageUrl = imageUrl
        self.addedByUser = addedByUser
    }

    init?(snapshot: DataSnapshot){
        guard
        let value = snapshot.value as? [String: AnyObject],
        let location = value["locationKey"] as? String,
        let date = value["date"] as? Int,
        let name = value["name"] as? String,
        let addmission = value["addmission"] as? String,
        let description = value["description"] as?  String?,
        let eventType = value["eventType"] as? String,
        let imageUrl = value["imageURL"] as? String?,
        let addedByUser = value["addedByUser"] as? String else {
                return nil
        }

        self.init(ref: snapshot.ref, key: snapshot.key, location: location, date: date, name: name, addmission: addmission, description: description, eventType: eventType, imageUrl: imageUrl, addedByUser: addedByUser)
    }

    func toAnyObject() -> Any {
        return [
            "locationKey": location,
            "date": date,
            "name": name,
            "addmission": addmission,
            "description": description as Any,
            "eventType": eventType,
            "imageURL": imageUrl as Any,
            "addedByUser": addedByUser
        ]
    }
}
