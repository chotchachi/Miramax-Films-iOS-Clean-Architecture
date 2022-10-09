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
    func saveBookmarkEntertainment(item: BookmarkEntertainment) -> Observable<Void>
    func removeBookmarkEntertainment(item: BookmarkEntertainment) -> Observable<Void>
    func removeAllBookmarkEntertainmentMovie() -> Observable<Void>
    func removeAllBookmarkEntertainmentTVShow() -> Observable<Void>
}
