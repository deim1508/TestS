//
//  AddEventViewModel.swift
//  events
//
//  Created by halcyon on 1/7/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol AddEventViewModel {
    var locations: [String] { get }
    func viewControllerViewDidLoad()
    func selectLocation(at index: Int)
    func selectDate(date: Date)
    func createEvent()
    func dismissScreen(on viewController: AddEventViewController)
}

protocol AddEventViewModelFlowDelegate: class {
    func dismiss(_ viewController: AddEventViewController)
    func showMissingLocationAlert()
    func didCreatedBaseEvent(event: Event)
}

class AddEventViewModelImpl: AddEventViewModel {
    weak var flowDelegate: AddEventViewModelFlowDelegate?
    var locations: [String] = []
    var items: [Location] = []
    var selectedLocation: Location!
    var selectedDate: Date = Date()

    func viewControllerViewDidLoad() {
        let itemsRef = Database.database().reference().child("locations")
        itemsRef.queryOrdered(byChild: "name").observe(.value) { snapshot in
            var newItems: [Location] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let location = Location(snapshot: snapshot) {
                    newItems.append(location)
                }
            }
            self.items = newItems
            self.locations = self.items.map({ (item) -> String in
                item.name
            })
        }
    }

    func selectLocation(at index: Int) {
        selectedLocation = items[index]
    }

    func selectDate(date: Date) {
        selectedDate = date
    }

    func createEvent() {
        guard let loc = selectedLocation else {
            flowDelegate?.showMissingLocationAlert()
            return
        }
        let dateToInt = Int(selectedDate.timeIntervalSince1970)
        let event: Event = Event(location: loc.key, date: dateToInt)
        flowDelegate?.didCreatedBaseEvent(event: event)
    }
    
    func dismissScreen(on viewController: AddEventViewController) {
        flowDelegate?.dismiss(viewController)
    }
}

extension Date {
    static func getFormattedDate(from date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm a"
        return dateFormatter.string(from: date)
    }

    static func getFormattedDateFromInt(dateInt: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(dateInt))
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}
