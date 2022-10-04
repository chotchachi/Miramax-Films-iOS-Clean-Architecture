//
//  AppFonts.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import UIKit

struct AppFonts {
    static func bold(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont(name: "Roboto-Black", size: size) ?? .systemFont(ofSize: size, weight: .bold)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }

    static func semiBold(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont(name: "Roboto-Bold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }

    static func thin(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont(name: "Roboto-Thin", size: size) ?? .systemFont(ofSize: size, weight: .thin)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }
    
    static func light(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont(name: "Roboto-Light", size: size) ?? .systemFont(ofSize: size, weight: .light)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }
    
    static func medium(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont(name: "Roboto-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }

    static func regular(withSize size: CGFloat, dynamic: Bool = true) -> UIFont {
        let font = UIFont(name: "Roboto-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
        if !dynamic { return font }
        return UIFontMetrics.default.scaledFont(for: font)
    }
}

extension AppFonts {
    static let headline = AppFonts.regular(withSize: 24.0)
    static let headlineMedium = AppFonts.medium(withSize: 24.0)
    static let headlineSemiBold = AppFonts.semiBold(withSize: 24.0)
    static let headlineBold = AppFonts.bold(withSize: 24.0)

    static let subhead = AppFonts.regular(withSize: 18.0)
    static let subheadMedium = AppFonts.medium(withSize: 18.0)
    static let subheadSemiBold = AppFonts.semiBold(withSize: 18.0)
    static let subheadBold = AppFonts.bold(withSize: 18.0)

    static let body = AppFonts.regular(withSize: 17.0)
    static let bodyMedium = AppFonts.medium(withSize: 17.0)
    static let bodySemiBold = AppFonts.semiBold(withSize: 17.0)
    static let bodyBold = AppFonts.bold(withSize: 17.0)

    static let caption1 = AppFonts.regular(withSize: 14.0)
    static let caption1Medium = AppFonts.medium(withSize: 14.0)
    static let caption1SemiBold = AppFonts.semiBold(withSize: 14.0)
    static let caption1Bold = AppFonts.bold(withSize: 14.0)

    static let caption2 = AppFonts.regular(withSize: 12.0)
    static let caption2Medium = AppFonts.medium(withSize: 12.0)
    static let caption2SemiBold = AppFonts.semiBold(withSize: 12.0)
    static let caption2Bold = AppFonts.bold(withSize: 12.0)
}
