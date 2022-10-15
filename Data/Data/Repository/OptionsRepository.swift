//
//  OptionsRepository.swift
//  Data
//
//  Created by Thanh Quang on 07/10/2022.
//

import Domain

public final class OptionsRepository: OptionsRepositoryProtocol {
    public func getSortOptions() -> [SortOption] {
        return [
            SortOption(text: "Popular", value: "popularity.desc"),
            SortOption(text: "Rating", value: "vote_average.desc"),
            SortOption(text: "Name A-Z", value: "original_title.asc"),
            SortOption(text: "Name Z-A", value: "original_title.desc")
        ]
    }
}
