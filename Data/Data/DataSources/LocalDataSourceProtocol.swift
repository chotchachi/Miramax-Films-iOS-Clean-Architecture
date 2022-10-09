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
    
    func getBookmarkEntertainments() -> Observable<[RMBookmarkEntertainment]>
    func saveBookmarkEntertainment(item: RMBookmarkEntertainment) -> Observable<Void>
    func removeBookmarkEntertainment(item: RMBookmarkEntertainment) -> Observable<Void>
    func removeAllBookmarkEntertainmentMovie() -> Observable<Void>
    func removeAllBookmarkEntertainmentTVShow() -> Observable<Void>
}
