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
    
    public func getBookmarkMovies() -> Observable<[RMBookmarkEntertainment]> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .queryAll()
            .map { items in items.filter { $0.type == .movie } }
    }
    
    public func saveBookmarkMovie(item: RMBookmarkEntertainment) -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .save(entity: item)
    }
    
    public func removeBookmarkMovie(item: RMBookmarkEntertainment) -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .delete(entity: item)
    }
    
    public func removeAllBookmarkMovie() -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .deleteAllMovies()
    }
    
    public func getBookmarkTVShows() -> Observable<[RMBookmarkEntertainment]> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .queryAll()
            .map { items in items.filter { $0.type == .tvShow } }
    }
    
    public func saveBookmarkTVShow(item: RMBookmarkEntertainment) -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .save(entity: item)
    }
    
    public func removeBookmarkTVShow(item: RMBookmarkEntertainment) -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .delete(entity: item)
    }
    
    public func removeAllBookmarkTVShow() -> Observable<Void> {
        return dbManager.getDao(BookmarkEntertainmentDao.self)
            .deleteAllTVShows()
    }
}
