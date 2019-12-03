//
//  CareTake.swift
//  events
//
//  Created by halcyon on 1/13/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import Foundation

protocol CareTake {
    var mementoList: [Memento] { get }
    func add(memento: Memento)
    func getMemento(at index: Int) -> Memento
    func removeLast()
}

class CareTakeImpl: CareTake {
    var mementoList: [Memento] = []

    func add(memento: Memento) {
        mementoList.append(memento)
    }

    func getMemento(at index: Int) -> Memento {
       return mementoList[index]
    }
    
    func removeLast() {
        mementoList.removeLast()
    }
}


