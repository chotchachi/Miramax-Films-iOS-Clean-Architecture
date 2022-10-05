//
//  SortOption.swift
//  Domain
//
//  Created by Thanh Quang on 05/10/2022.
//

import Foundation

public enum SortOption: CaseIterable {
    case nameA_Z, nameZ_A, rating
    
    public var text: String {
        switch self {
        case .nameA_Z:
            return "Name A-Z"
        case .nameZ_A:
            return "Name Z-A"
        case .rating:
            return "Rating"
        }
    }
    
    public var value: String {
        switch self {
        case .nameA_Z:
            return "original_title.asc"
        case .nameZ_A:
            return "original_title.desc"
        case .rating:
            return "vote_average.desc"
        }
    }
}
