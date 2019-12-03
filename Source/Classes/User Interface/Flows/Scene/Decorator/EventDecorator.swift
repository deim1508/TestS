//
//  EventDecorator.swift
//  events
//
//  Created by halcyon on 1/10/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

protocol EventDecorator: EventT {
    var imageView: UIImageView { get }
}
