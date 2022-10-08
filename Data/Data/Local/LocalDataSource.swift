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
}
