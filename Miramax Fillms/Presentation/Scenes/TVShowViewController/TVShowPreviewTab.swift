//
//  TVShowPreviewTab.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 06/10/2022.
//

enum TVShowPreviewTab: CaseIterable {
    case topRating
    case news
    case trending
    
    var title: String {
        switch self {
        case .topRating:
            return "top_rating".localized
        case .news:
            return "news".localized
        case .trending:
            return "trending".localized
        }
    }
    
    static var defaultTab: TVShowPreviewTab = .news
}
