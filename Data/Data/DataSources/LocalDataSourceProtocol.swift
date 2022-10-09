//
//  LocalDataSourceProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

public protocol LocalDataSourceProtocol {
    func getSearchRecentEntertainments() -> Observable<[RMRecentEntertainment]>
    func saveSearchRecentEntertainments(item: RMRecentEntertainment) -> Observable<Void>
    func removeAllRecentEntertainment() -> Observable<Void>
    
    func getBookmarkPersons() -> Observable<[RMBookmarkPerson]>
    func saveBookmarkPerson(item: RMBookmarkPerson) -> Observable<Void>
    func removeBookmarkPerson(item: RMBookmarkPerson) -> Observable<Void>
    func removeAllBookmarkPerson() -> Observable<Void>
    
    func getBookmarkMovies() -> Observable<[RMBookmarkEntertainment]>
    func saveBookmarkMovie(item: RMBookmarkEntertainment) -> Observable<Void>
    func removeBookmarkMovie(item: RMBookmarkEntertainment) -> Observable<Void>
    func removeAllBookmarkMovie() -> Observable<Void>
    
    func getBookmarkTVShows() -> Observable<[RMBookmarkEntertainment]>
    func saveBookmarkTVShow(item: RMBookmarkEntertainment) -> Observable<Void>
    func removeBookmarkTVShow(item: RMBookmarkEntertainment) -> Observable<Void>
    func removeAllBookmarkTVShow() -> Observable<Void>
}
