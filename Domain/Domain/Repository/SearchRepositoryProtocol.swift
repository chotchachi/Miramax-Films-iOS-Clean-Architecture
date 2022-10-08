//
//  SearchRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import RxSwift

public protocol SearchRepositoryProtocol {
    func searchMovie(query: String, page: Int?) -> Single<BaseResponse<Movie>>
    func searchTVShow(query: String, page: Int?) -> Single<BaseResponse<TVShow>>
    func searchPerson(query: String, page: Int?) -> Single<BaseResponse<Person>>
    func getRecentEntertainment() -> Observable<[RecentEntertainment]>
    func addRecentEntertainment(item: RecentEntertainment) -> Observable<Void>
    func removeAllRecentEntertainment() -> Observable<Void>
}
