//
//  PartyDecorator.swift
//  events
//
//  Created by halcyon on 1/10/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

class PartyDecorator: EventDecorator {
    var imageView: UIImageView

    init(imageView: UIImageView) {
        self.imageView = imageView
    }

    func setImage() {
        imageView.image = #imageLiteral(resourceName: "icon_party")
    }
}
