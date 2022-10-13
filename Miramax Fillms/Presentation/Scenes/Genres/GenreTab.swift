//
//  GenreTab.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/10/2022.
//

enum GenreTab: CaseIterable {
    case movies
    case shows
    
    var title: String {
        switch self {
        case .movies:
            return "movies".localized
        case .shows:
            return "tvshows".localized
        }
    }
    
    static var defaultTab: GenreTab = .movies
}
