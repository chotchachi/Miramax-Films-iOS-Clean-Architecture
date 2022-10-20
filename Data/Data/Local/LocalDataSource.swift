//
//  LocalDataSource.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

public final class LocalDataSource: LocalDataSourceProtocol {
    private let dbManager: DBManager

    public init(dbManager: DBManager) {
        self.dbManager = dbManager
    }
    
    public func getSearchRecentEntertainments() -> Observable<[RMRecentEntertainment]> {
        return dbManager.getDao(RecentEntertainmentDao.self)
            .queryAll()
    }
    
    public func saveSearchRecentEntertainments(item: RMRecentEntertainment) -> Completable {
        return dbManager.getDao(RecentEntertainmentDao.self)
            .save(entity: item)
    }
    
    public func removeAllRecentEntertainment() -> Completable {
        return dbManager.getDao(RecentEntertainmentDao.self)
            .deleteAll()
    }
    
    public func getBookmarkPersons() -> Observable<[RMBookmarkPerson]> {
        return dbManager.getDao(BookmarkPersonDao.self)
            .queryAll()
    }
    
    public func saveBookmarkPerson(item: RMBookmarkPerson) -> Completable {
        return dbManager.getDao(BookmarkPersonDao.self)
            .save(entity: item)
    }
    
    public func removeBookmarkPerson(item: RMBookmarkPerson) -> Completable {
        return dbManager.getDao(BookmarkPersonDao.self)
            .delete(entity: item)
    }
    
    public func removeAllBookmarkPerson() -> Completable {
        return dbManager.getDao(BookmarkPersonDao.self)
            .deleteAll()
    }
    
    public func getBookmarkEntertainments() -> Observable<[RMBookmarkEntertainment]> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .queryAll()
    }
    
    public func saveBookmarkEntertainment(item: RMBookmarkEntertainment) -> Completable {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .save(entity: item)
    }
    
    public func removeBookmarkEntertainment(item: RMBookmarkEntertainment) -> Completable {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .delete(entity: item)
    }
    
    public func removeAllBookmarkEntertainmentMovie() -> Completable {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .deleteAllMovies()
    }
    
    public func removeAllBookmarkEntertainmentTVShow() -> Completable {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .deleteAllTVShows()
    }
    
    public func getAllFavoriteSelfie() -> Observable<[RMFavoriteSelfie]> {
        return dbManager.getDao(FavoriteSelfieDao.self)
            .queryAll()
    }
    
    public func saveFavoriteSelfie(item: RMFavoriteSelfie) -> Completable {
        return dbManager.getDao(FavoriteSelfieDao.self)
            .save(entity: item)
    }
}
