//
//  MoviePreviewTab.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 06/10/2022.
//

enum MoviePreviewTab: CaseIterable {
    case topRating
    case nowPlaying
    case trending
    
    var title: String {
        switch self {
        case .topRating:
            return "top_rating".localized
        case .nowPlaying:
            return "now_playing".localized
        case .trending:
            return "trending".localized
        }
    }
    
    static var defaultTab: MoviePreviewTab = .nowPlaying
}
