//
//  SetThemeViewModel.swift
//  events
//
//  Created by halcyon on 12/29/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import Foundation

protocol SetThemeViewModel {
    func applyTheme(at index: Int)
    func dismissScreen()
}

protocol SetThemeViewModelFlowDelegate: class {
    func dismiss()
    func showErrorAlert()
}

class SetThemeViewModelImpl: SetThemeViewModel {
    weak var flowDelegate: SetThemeViewModelFlowDelegate?

    func applyTheme(at index: Int) {
        switch index {
        case 0...2:
            guard let theme = Theme(rawValue: index) else { return }
            theme.apply()
            flowDelegate?.dismiss()
        default:
            flowDelegate?.showErrorAlert()
        }
    }
    
    func dismissScreen() {
        flowDelegate?.dismiss()
    }
}
