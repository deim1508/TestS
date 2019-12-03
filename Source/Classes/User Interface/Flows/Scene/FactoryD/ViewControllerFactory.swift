//
//  ViewControllerFactory.swift
//  events
//
//  Created by Halcyon on 16/01/2019.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

enum ViewControllerType {
    case favouritesV
    case setEventDetailV
    case addEventV
    case eventListV
}

protocol ViewControllerFactory {
    func getViewC(type: ViewControllerType, eventType: EventsType?) -> BaseViewController
}

class ViewControllerFactoryImpl: ViewControllerFactory {
    func getViewC(type: ViewControllerType, eventType: EventsType? = nil) -> BaseViewController {
        switch type {
        case .favouritesV:
            return FavouriteEventViewController()
        case .setEventDetailV:
            return SetEventDetailViewController()
        case .addEventV:
            return AddEventViewController()
        case .eventListV:
            return EventListViewController(type: eventType!)
        }
    }
}
