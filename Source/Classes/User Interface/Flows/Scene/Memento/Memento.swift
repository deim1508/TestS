//
//  Memento.swift
//  events
//
//  Created by halcyon on 1/13/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import Foundation

protocol Memento {
    var state: [Event] { get }
    var stateCell: [FavouriteCellViewModel] { get }
    func getState() -> ([Event], [FavouriteCellViewModel])
}

class MementoImpl: Memento {
    var state: [Event]
    var stateCell: [FavouriteCellViewModel]

    init(state: [Event], stateCell: [FavouriteCellViewModel]) {
        self.state = state
        self.stateCell = stateCell
    }

    func getState() -> ([Event], [FavouriteCellViewModel]) {
        return (state, stateCell)
    }
}
