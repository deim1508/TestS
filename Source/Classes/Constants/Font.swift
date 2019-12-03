//
//  Font.swift
//  events
//
//  Created by halcyon on 12/11/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
    /// 11
    case extraSmall = 11
    /// 14
    case mediumSmall = 14
    /// 16
    case medium = 16
    /// 18
    case moreThanMedium = 18
    /// 20
    case greaterThanMedium = 20
    /// 24
    case large = 24
    ///30
    case greaterThanLarge = 30
    /// 32
    case extraLarge = 32
}

private struct FontFamily {
    enum CircularStd: String, FontConvertible {
        case book            = "CircularStd-Book"
        case regular          = "CircularStd-Medium"
        case bold             = "CircularStd-Bold"
        case black            = "CircularStd-Black"
    }
}

struct Font {
    static func light(size: FontSize) -> UIFont {
        return FontFamily.CircularStd.book.font(size: size)
    }

    static func regular(size: FontSize) -> UIFont {
        return FontFamily.CircularStd.regular.font(size: size)
    }

    static func bold(size: FontSize) -> UIFont {
        return FontFamily.CircularStd.bold.font(size: size)
    }

    static func black(size: FontSize) -> UIFont {
        return FontFamily.CircularStd.black.font(size: size)
    }
}

protocol FontConvertible {
    func font(size: FontSize) -> UIFont!
}

extension FontConvertible where Self: RawRepresentable, Self.RawValue == String {
    func font(size: FontSize) -> UIFont! {
        return UIFont(name: self.rawValue, size: size.rawValue)
    }
}

