//
//  WishlistPreviewTab.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 09/10/2022.
//

enum WishlistPreviewTab: CaseIterable {
    case movies
    case shows
    case actors
    
    var title: String {
        switch self {
        case .movies:
            return "movies".localized
        case .shows:
            return "tvshows".localized
        case .actors:
            return "actors".localized
        }
    }
    
    static var defaultTab: WishlistPreviewTab = .movies
}
