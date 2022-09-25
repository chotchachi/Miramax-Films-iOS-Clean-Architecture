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
    
    static func medium(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
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
    static let headline = AppFonts.regular(withSize: 24.0)
    static let headlineSemiBold = AppFonts.semiBold(withSize: 24.0)
    static let headlineBold = AppFonts.bold(withSize: 24.0)

    static let subhead = AppFonts.regular(withSize: 18.0)
    static let subheadLight = AppFonts.light(withSize: 18.0)
    static let subheadSemiBold = AppFonts.semiBold(withSize: 18.0)
    static let subheadBold = AppFonts.bold(withSize: 18.0)

    static let body = AppFonts.regular(withSize: 17.0)
    static let bodySemiBold = AppFonts.semiBold(withSize: 17.0)
    static let bodyBold = AppFonts.bold(withSize: 17.0)

    static let callout = AppFonts.regular(withSize: 14.0)
    static let calloutMedium = AppFonts.medium(withSize: 14.0)
    static let calloutLight = AppFonts.light(withSize: 14.0)
    static let calloutSemiBold = AppFonts.semiBold(withSize: 14.0)

    static let caption1 = AppFonts.regular(withSize: 14.0)
    static let caption1Medium = AppFonts.medium(withSize: 14.0)
    static let caption1Semibold = AppFonts.semiBold(withSize: 14.0)
    
    static let caption2 = AppFonts.regular(withSize: 12.0)
    static let caption2Medium = AppFonts.medium(withSize: 12.0)
    static let caption2Semibold = AppFonts.semiBold(withSize: 12.0)
}
