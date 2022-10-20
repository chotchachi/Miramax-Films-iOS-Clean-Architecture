//
//  BookmarkEntertainmentDao.swift
//  Data
//
//  Created by Thanh Quang on 09/10/2022.
//

import RealmSwift
import RxSwift
import RxRealm

final class BookmarkEntertainmentDao: BaseDao {
    
    required init(config: Realm.Configuration) {
        super.init(config: config)
    }
    
    func queryAll() -> Observable<[RMBookmarkEntertainment]> {
        return Observable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMBookmarkEntertainment.self)
            return Observable.array(from: objects)
        }
    }
    
    func save(entity: RMBookmarkEntertainment) -> Completable {
        return Completable.deferred {
            return self.realmInstance().rx.save(entity: entity)
        }
    }

    func delete(entity: RMBookmarkEntertainment) -> Completable {
        return Completable.deferred {
            return self.realmInstance().rx.delete(entity: entity)
        }
    }

    func deleteAllMovies() -> Completable {
        return Completable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMBookmarkEntertainment.self)
                .toArray()
                .filter { $0.type == .movie }
            return realm.rx.delete(entities: objects)
        }
    }
    
    func deleteAllTVShows() -> Completable {
        return Completable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMBookmarkEntertainment.self)
                .toArray()
                .filter { $0.type == .tvShow }
            return realm.rx.delete(entities: objects)
        }
    }
}
