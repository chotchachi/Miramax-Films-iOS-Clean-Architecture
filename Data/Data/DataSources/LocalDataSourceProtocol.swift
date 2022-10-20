//
//  LocalDataSourceProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

public protocol LocalDataSourceProtocol {
    func getSearchRecentEntertainments() -> Observable<[RMRecentEntertainment]>
    func saveSearchRecentEntertainments(item: RMRecentEntertainment) -> Completable
    func removeAllRecentEntertainment() -> Completable
    
    func getBookmarkPersons() -> Observable<[RMBookmarkPerson]>
    func saveBookmarkPerson(item: RMBookmarkPerson) -> Completable
    func removeBookmarkPerson(item: RMBookmarkPerson) -> Completable
    func removeAllBookmarkPerson() -> Completable
    
    func getBookmarkEntertainments() -> Observable<[RMBookmarkEntertainment]>
    func saveBookmarkEntertainment(item: RMBookmarkEntertainment) -> Completable
    func removeBookmarkEntertainment(item: RMBookmarkEntertainment) -> Completable
    func removeAllBookmarkEntertainmentMovie() -> Completable
    func removeAllBookmarkEntertainmentTVShow() -> Completable
    
    func getAllFavoriteSelfie() -> Observable<[RMFavoriteSelfie]>
    func saveFavoriteSelfie(item: RMFavoriteSelfie) -> Completable
}
