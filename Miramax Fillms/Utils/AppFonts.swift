//
//  AppFonts.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import UIKit

struct AppFonts {
    static func bold(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }

    static func semiBold(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }

    static func light(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }

    static func regular(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }
}

extension AppFonts {
    static let headline = AppFonts.semiBold(withSize: 21.0)
    static let headlineBold = AppFonts.bold(withSize: 21.0)

    static let body = AppFonts.regular(withSize: 17.0)
    static let bodySemiBold = AppFonts.semiBold(withSize: 17.0)
    static let bodyBold = AppFonts.bold(withSize: 17.0)

    static let callout = AppFonts.regular(withSize: 16.0)
    static let calloutLight = AppFonts.light(withSize: 16.0)
    static let calloutSemiBold = AppFonts.semiBold(withSize: 16.0)

    static let subhead = AppFonts.regular(withSize: 15.0)
    static let subheadLight = AppFonts.light(withSize: 15.0)
    static let subheadBold = AppFonts.bold(withSize: 15.0)

    static let footnote = AppFonts.regular(withSize: 13.0)
    static let footnoteLight = AppFonts.light(withSize: 13.0)

    static let caption1 = AppFonts.regular(withSize: 12.0)
    static let caption1Light = AppFonts.light(withSize: 12.0)
    static let caption2 = AppFonts.regular(withSize: 11.0)
}
