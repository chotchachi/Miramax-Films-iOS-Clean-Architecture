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
    
    public func saveSearchRecentEntertainments(item: RMRecentEntertainment) -> Observable<Void> {
        return dbManager.getDao(RecentEntertainmentDao.self)
            .save(entity: item)
    }
    
    public func removeAllRecentEntertainment() -> Observable<Void> {
        return dbManager.getDao(RecentEntertainmentDao.self)
            .deleteAll()
    }
    
    public func getBookmarkPersons() -> Observable<[RMBookmarkPerson]> {
        return dbManager.getDao(BookmarkPersonDao.self)
            .queryAll()
    }
    
    public func saveBookmarkPerson(item: RMBookmarkPerson) -> Observable<Void> {
        return dbManager.getDao(BookmarkPersonDao.self)
            .save(entity: item)
    }
    
    public func removeBookmarkPerson(item: RMBookmarkPerson) -> Observable<Void> {
        return dbManager.getDao(BookmarkPersonDao.self)
            .delete(entity: item)
    }
    
    public func removeAllBookmarkPerson() -> Observable<Void> {
        return dbManager.getDao(BookmarkPersonDao.self)
            .deleteAll()
    }
    
    public func getBookmarkEntertainments() -> Observable<[RMBookmarkEntertainment]> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .queryAll()
    }
    
    public func saveBookmarkEntertainment(item: RMBookmarkEntertainment) -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .save(entity: item)
    }
    
    public func removeBookmarkEntertainment(item: RMBookmarkEntertainment) -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .delete(entity: item)
    }
    
    public func removeAllBookmarkEntertainmentMovie() -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .deleteAllMovies()
    }
    
    public func removeAllBookmarkEntertainmentTVShow() -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .deleteAllTVShows()
    }
}
