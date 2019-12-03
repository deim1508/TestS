//
//  UserDefaults.swift
//  events
//
//  Created by halcyon on 1/11/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

protocol FavouriteEventService {
    func actualizeFavouritEvents(eventKey: String)
    func containsGivenEvent(eventKey: String) -> Bool
    func getFavouriteEvents() -> [String]
}

class FavouriteEventServiceImpl: FavouriteEventService {
    private let favouriteEventKey = "favouriteEvents"
    private var favouriteEvents: [String]

    init() {
        favouriteEvents = (UserDefaults.standard.array(forKey: favouriteEventKey) as? [String]) ?? []
    }

    func actualizeFavouritEvents(eventKey: String) {
        if !containsGivenEvent(eventKey: eventKey) {
            favouriteEvents.append(eventKey)
        } else {
            favouriteEvents = getFavouriteEvents().filter({ $0 != eventKey })
        }
        UserDefaults.standard.set(favouriteEvents, forKey: favouriteEventKey)
    }

    func containsGivenEvent(eventKey: String) -> Bool {
        let events = getFavouriteEvents()
        return events.contains(eventKey)
    }

    func getFavouriteEvents() -> [String] {
        return UserDefaults.standard.object(forKey: favouriteEventKey) as? [String] ?? []
    }
}
