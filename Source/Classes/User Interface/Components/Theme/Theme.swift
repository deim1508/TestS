//
//  Theme.swift
//  events
//
//  Created by halcyon on 12/21/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

enum Theme: Int {
    case `default`, dark, graphical

    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }

    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }

    var mainColor: UIColor {
        switch self {
        case .default:
            return Color.malibu
        case .dark:
            return Color.burningOrange
        case .graphical:
            return Color.monzaRed
        }
    }

    var barStyle: UIBarStyle {
        switch self {
        case .default:
            return .default
        case .dark, .graphical:
            return .black
        }
    }

    var navigationBackgroundImage: UIImage? {
        return self == .graphical ? #imageLiteral(resourceName: "nav") : nil
    }

    var tabBarBackgroundImage: UIImage? {
        return self == .graphical ? #imageLiteral(resourceName: "tab") : nil
    }

    var backgroundColor: UIColor {
        switch self {
        case .default:
            return Color.white
        case .dark, .graphical:
            return UIColor(white: 0.4, alpha: 1.0)
        }
    }

    var textColor: UIColor {
        switch self {
        case .default:
            return Color.black
        case .dark, .graphical:
            return Color.white
        }
    }
    
    func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UIApplication.shared.delegate?.window??.tintColor = mainColor

        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().setBackgroundImage(navigationBackgroundImage, for: .default)
        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrowMask")

        UITabBar.appearance().barStyle = barStyle
        UITabBar.appearance().backgroundImage = tabBarBackgroundImage

        UITableView.appearance().backgroundColor = backgroundColor
        UITableViewCell.appearance().backgroundColor = backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [UIVisualEffectView.self]).textColor = textColor
    }
}
