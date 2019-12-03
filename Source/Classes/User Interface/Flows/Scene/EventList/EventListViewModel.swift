//
//  EventListViewModel.swift
//  events
//
//  Created by halcyon on 12/14/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol EventListViewModel {
    var viewDelegate: EventListViewDelegate? { get set }
    var events: [Event] { get }
    var userEvents: [Event] { get }
    var eventsCells: [EventCellViewModel] { get }
    var userEventsCells: [EventCellViewModel] { get }
    func didTappLogOut()
    func didTappSettings()
    func viewControllerViewDidLoad(on screenType: EventsType)
    func removeEvent(at index: Int, screenType: EventsType)
    func seeAllFavouriteEvent()
}

protocol EventListViewDelegate: class {
    func shouldReloadData()
}

protocol EventListViewModelFlowDelegate: class {
    func shouldChangeToFavouritesView(service: FavouriteEventService)
    func didLogOut()
    func didPresentSetThemeVC()
}

class EventListViewModelImpl: EventListViewModel {
    weak var viewDelegate: EventListViewDelegate?
    weak var flowDelegate: EventListViewModelFlowDelegate?
    var events: [Event] = []
    var userEvents: [Event] = []
    var eventsCells: [EventCellViewModel] = []
    var userEventsCells: [EventCellViewModel] = []
    let favouriteEventService: FavouriteEventService

    init(service: FavouriteEventService) {
        favouriteEventService = service
    }

    func viewControllerViewDidLoad(on screenType: EventsType) {
        let itemsRef = Database.database().reference().child("events")
        itemsRef.queryOrdered(byChild: "date").observe(.value)  { snapshot in
            var newItems: [Event] = []
            self.eventsCells = []
            self.userEventsCells = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let event = Event(snapshot: snapshot) {
                    newItems.append(event)
                    let cellViewModel = EventCellViewModelImpl(event: event, service: self.favouriteEventService, type: screenType)
                    cellViewModel.flowDelegate = self
                    self.eventsCells.append(cellViewModel)
                }
            }
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let filtered = newItems.compactMap({ event -> Event? in
                if event.addedByUser == userId {
                    let cellViewModel = EventCellViewModelImpl(event: event, service: self.favouriteEventService, type: screenType)
                    cellViewModel.flowDelegate = self
                    self.userEventsCells.append(cellViewModel)
                    return event
                }
                return nil
            })
            self.userEvents = filtered
            self.events = newItems
            self.viewDelegate?.shouldReloadData()
        }
    }

    func removeEvent(at index: Int, screenType: EventsType) {
        switch screenType {
        case .allEvent:
            events[index].ref?.removeValue()
        case .myEvents:
            userEvents[index].ref?.removeValue()
        }
        viewDelegate?.shouldReloadData()
    }

    func seeAllFavouriteEvent() {
        flowDelegate?.shouldChangeToFavouritesView(service: favouriteEventService)
    }
    
    func didTappSettings() {
        flowDelegate?.didPresentSetThemeVC()
    }

    func didTappLogOut() {
        flowDelegate?.didLogOut()
    }
}

extension EventListViewModelImpl: EventCellViewModelDelegate {
    func didChangedEventStatus(eventKey: String) {
        favouriteEventService.actualizeFavouritEvents(eventKey: eventKey)
    }
}
