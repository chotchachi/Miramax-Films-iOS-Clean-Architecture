//
//  SearchRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import RxSwift

protocol SearchRepositoryProtocol {
    func searchMovie(query: String, page: Int?) -> Single<MovieResponse>
    func searchTVShow(query: String, page: Int?) -> Single<TVShowResponse>
    func searchPerson(query: String, page: Int?) -> Single<PersonResponse>
}
