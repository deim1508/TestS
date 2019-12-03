//
//  Originator.swift
//  events
//
//  Created by halcyon on 1/13/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import Foundation

protocol Originator {
    var state: [Event] { get set }
    var stateCell: [FavouriteCellViewModel] { get set }
    func setState(state: [Event], stateCell: [FavouriteCellViewModel])
    func getState() -> ([Event], [FavouriteCellViewModel])
    func saveStateToMemento() -> Memento
    func getStateFromMemento(memento: Memento)
}

class OriginatorImpl: Originator {
    var state: [Event]
    var stateCell: [FavouriteCellViewModel]

    init(state: [Event], stateCell: [FavouriteCellViewModel]) {
        self.state = state
        self.stateCell = stateCell
    }

    func setState(state: [Event], stateCell: [FavouriteCellViewModel]) {
        self.state = state
        self.stateCell = stateCell
    }

    func getState() -> ([Event], [FavouriteCellViewModel]) {
        return (state, stateCell)
    }

    func saveStateToMemento() -> Memento {
        return MementoImpl(state: state, stateCell: stateCell)
    }

    func getStateFromMemento(memento: Memento) {
        (state, stateCell) = memento.getState()
    }
}
