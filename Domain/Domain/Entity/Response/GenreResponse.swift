//
//  GenreResponse.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

public struct GenreResponse: Equatable {
    public let genres: [Genre]
    
    public init(genres: [Genre]) {
        self.genres = genres
    }
}
