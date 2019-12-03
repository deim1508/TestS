//
//  EventCellViewModel.swift
//  events
//
//  Created by halcyon on 1/7/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol EventCellViewModel {
    var viewDelegate: EventCellViewCellDelegate? { get set }
    var title: String { get }
    var date: String { get }
    var eventImageUrl: URL? { get }
    var isFavourite: Bool { get }
    var eventTypeName: String { get }
    var screenType: EventsType { get }
    func didTappFavourite()
}

protocol EventCellViewModelDelegate: class {
    func didChangedEventStatus(eventKey: String)
}

protocol EventCellViewCellDelegate: class {
    func shouldChangeFavouriteIconColor()
}

class EventCellViewModelImpl: EventCellViewModel {
    weak var flowDelegate: EventCellViewModelDelegate?
    weak var viewDelegate: EventCellViewCellDelegate?
    let title: String
    let eventImageUrl: URL?
    let date: String
    var isFavourite: Bool
    let event: Event
    let eventTypeName: String
    let favouriteEventService: FavouriteEventService
    let screenType: EventsType

    init(event: Event, service: FavouriteEventService, type: EventsType) {
        self.event = event
        self.title = event.name
        self.eventImageUrl = URL(string: event.imageUrl!)
        self.date = Date.getFormattedDateFromInt(dateInt: event.date)
        self.eventTypeName = event.eventType
        favouriteEventService = service
        isFavourite = favouriteEventService.containsGivenEvent(eventKey: event.key)
        screenType = type
    }

    func didTappFavourite() {
        isFavourite = !isFavourite
        viewDelegate?.shouldChangeFavouriteIconColor()
        flowDelegate?.didChangedEventStatus(eventKey: event.key)
    }
}
