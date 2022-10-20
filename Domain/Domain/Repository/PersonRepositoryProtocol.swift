//
//  PersonRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxSwift

public protocol PersonRepositoryProtocol {
    func getPersonDetail(personId: Int) -> Single<Person>
    func getBookmarkPersons() -> Observable<[BookmarkPerson]>
    func saveBookmarkPerson(item: BookmarkPerson) -> Completable
    func removeBookmarkPerson(item: BookmarkPerson) -> Completable
    func removeAllBookmarkPerson() -> Completable
}
