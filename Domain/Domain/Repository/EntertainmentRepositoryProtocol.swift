//
//  EntertainmentRepositoryProtocol.swift
//  Domain
//
//  Created by Thanh Quang on 09/10/2022.
//

import RxSwift

public protocol EntertainmentRepositoryProtocol {
    func getAllBookmarkEntertainment() -> Observable<[BookmarkEntertainment]>
    func getAllBookmarkEntertainmentMovie() -> Observable<[BookmarkEntertainment]>
    func getAllBookmarkEntertainmentTVShow() -> Observable<[BookmarkEntertainment]>
    func saveBookmarkEntertainment(item: BookmarkEntertainment) -> Completable
    func removeBookmarkEntertainment(item: BookmarkEntertainment) -> Completable
    func removeAllBookmarkEntertainmentMovie() -> Completable
    func removeAllBookmarkEntertainmentTVShow() -> Completable
}
