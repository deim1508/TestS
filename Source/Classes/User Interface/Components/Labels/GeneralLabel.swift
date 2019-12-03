//
//  Labels.swift
//  events
//
//  Created by halcyon on 1/9/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

enum LabelType {
    case title
    case location
    case start
    case addmission
    case eventType
    case description

    var text: String {
        switch self {
        case .title:
            return Strings.name
        case .location:
            return Strings.location
        case .start:
            return Strings.start
        case .addmission:
            return Strings.addmissionFee
        case .eventType:
            return Strings.eventType
        case .description:
            return Strings.description
        }
    }
}
class GeneralLabel: UILabel {
    private var type: LabelType

    init(type: LabelType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        font = Font.regular(size: .moreThanMedium)
        textColor = Color.darkGray
        text = type.text
        adjustsFontSizeToFitWidth = true
    }
}
