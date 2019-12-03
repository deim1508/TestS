//
//  FavouriteCellViewModel.swift
//  events
//
//  Created by halcyon on 1/11/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import Foundation

protocol FavouriteCellViewModel {
    var title: String { get }
    var date: String { get }
    var eventImageUrl: URL? { get }
    var price: String { get }
    func didTappFavourite()
}

protocol FavouriteCellViewFlowDelegate: class {
    func shouldRemoveEventFromFavourites(event: Event)
}

class FavouriteCellViewModelImpl: FavouriteCellViewModel {
    weak var flowDelegate: FavouriteCellViewFlowDelegate?
    let title: String
    let eventImageUrl: URL?
    let date: String
    let price: String
    let event: Event

    init(event: Event) {
        self.event = event
        self.title = event.name
        self.eventImageUrl = URL(string: event.imageUrl!)
        self.date = Date.getFormattedDateFromInt(dateInt: event.date)
        self.price = event.addmission
    }

    func didTappFavourite() {
        flowDelegate?.shouldRemoveEventFromFavourites(event: event)
    }
}
