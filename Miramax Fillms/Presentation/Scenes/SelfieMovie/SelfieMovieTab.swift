//
//  SelfieMovieTab.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/10/2022.
//

enum SelfieMovieTab: CaseIterable {
    case popular
    case favorite
    
    var title: String {
        switch self {
        case .popular:
            return "popular".localized
        case .favorite:
            return "favorite".localized
        }
    }
    
    static var defaultTab: SelfieMovieTab = .popular
}
