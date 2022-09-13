//
//  MovieRepositoryImpl.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift

final class MovieRepositoryImpl: MovieRepository {
    private let api: Api
    
    init(api: Api) {
        self.api = api
    }
    
    func getGenreList() -> Single<GenreResponse> {
        return api.getMovieGenreList()
            .map { $0.asDomain() }
    }
}
