//
//  LocalDataSource.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

final class LocalDataSource: LocalDataSourceProtocol {
    private let dbManager: DBManager

    init(dbManager: DBManager) {
        self.dbManager = dbManager
    }
    
    func getSearchRecentEntertainments() -> Observable<[RMRecentEntertainment]> {
        return dbManager.getDao(RecentEntertainmentDao.self)
            .queryAll()
    }
    
    func saveSearchRecentEntertainments(item: RMRecentEntertainment) -> Observable<Void> {
        return dbManager.getDao(RecentEntertainmentDao.self)
            .save(entity: item)
    }
}
