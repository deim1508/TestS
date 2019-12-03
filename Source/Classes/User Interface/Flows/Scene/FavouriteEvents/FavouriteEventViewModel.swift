//
//  FavouriteEventsViewModel.swift
//  events
//
//  Created by halcyon on 1/11/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FavouriteEventViewModel {
    var viewDelegate: FavouriteEventViewDelegate? { get set }
    var eventsCollectionCell: [FavouriteCellViewModel] { get }
    func viewControllerViewDidLoad()
    func actualizeFavouriteInUserDefaults()
    func resetFavourites()
    func didSelectCell(at index: Int)
}

protocol FavouriteEventViewDelegate: class {
    func shouldReloadData()
    func setResetButtonVisible(setHidden: Bool)
    func shouldChangeLocationOnMap(name: String, latitude: Double, longitude: Double)
}

class FavouriteEventViewModelImpl: FavouriteEventViewModel {
    weak var viewDelegate: FavouriteEventViewDelegate?
    let service: FavouriteEventService
    var events: [Event] = []
    var removedEvent: [Event] = []
    var eventsCollectionCell: [FavouriteCellViewModel] = []
    let originator: Originator = OriginatorImpl(state: [], stateCell: [])
    let careTake: CareTake = CareTakeImpl()

    init(service: FavouriteEventService) {
        self.service = service
    }
    
    func viewControllerViewDidLoad() {
       getEvents()
    }

    func actualizeFavouriteInUserDefaults() {
        guard events.count != service.getFavouriteEvents().count else { return }
        for event in removedEvent {
            service.actualizeFavouritEvents(eventKey: event.key)
        }
    }

    private func getEvents() {
        let eventKeys = service.getFavouriteEvents()
        let itemsRef = Database.database().reference().child("events")
        itemsRef.queryOrdered(byChild: "date").observe(.value)  { snapshot in
            var newItems: [Event] = []
            self.eventsCollectionCell = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let event = Event(snapshot: snapshot) {
                    newItems.append(event)
                }
            }
            let filtered = newItems.compactMap({ event -> Event? in
                if eventKeys.contains(event.key) {
                    let cellViewModel = FavouriteCellViewModelImpl(event: event)
                    cellViewModel.flowDelegate = self
                    self.eventsCollectionCell.append(cellViewModel)
                    return event
                }
                return nil
            })
            self.events = filtered
            self.viewDelegate?.shouldReloadData()
            self.originator.setState(state: self.events, stateCell: self.eventsCollectionCell)
            self.careTake.add(memento: self.originator.saveStateToMemento())
        }
    }

    func resetFavourites() {
        if careTake.mementoList.count > 1 {
            originator.getStateFromMemento(memento: careTake.getMemento(at: (careTake.mementoList.count - 2)))
            let (eventss, vms) = originator.getState()
            events = eventss
            eventsCollectionCell = vms
            removedEvent.removeLast()
            careTake.removeLast()
            viewDelegate?.shouldReloadData()
            viewDelegate?.setResetButtonVisible(setHidden: careTake.mementoList.count == 1)
        } else {
            viewDelegate?.setResetButtonVisible(setHidden: true)
        }
    }
    
    func didSelectCell(at index: Int) {
        let ref = Database.database().reference(withPath: "locations/\(events[index].location)")
        ref.observe(.value) { snapshot in
                if let location = Location(snapshot: snapshot) {
                self.viewDelegate?.shouldChangeLocationOnMap(name: location.name, latitude: location.latitude, longitude: location.longitude)
            }
        }
    }
}

extension FavouriteEventViewModelImpl: FavouriteCellViewFlowDelegate {
    func shouldRemoveEventFromFavourites(event: Event) {
        let index = events.index { (ev) -> Bool in
            if ev.key == event.key {
                self.removedEvent.append(ev)
                return true
            }
            return false
        }
        guard let ind = index else { return }
        events.remove(at: ind)
        eventsCollectionCell.remove(at: ind)
        originator.setState(state: events, stateCell: eventsCollectionCell)
        careTake.add(memento: originator.saveStateToMemento())
        viewDelegate?.setResetButtonVisible(setHidden: false)
        viewDelegate?.shouldReloadData()
    }
}
