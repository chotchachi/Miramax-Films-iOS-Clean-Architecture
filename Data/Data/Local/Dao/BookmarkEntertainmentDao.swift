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
    
    func save(entity: RMBookmarkEntertainment) -> Observable<Void> {
        return Observable.deferred {
            return self.realmInstance().rx.save(entity: entity)
        }
    }

    func update(entity: RMBookmarkEntertainment) -> Observable<Void> {
        return Observable.deferred {
            return self.realmInstance().rx.save(entity: entity, update: true)
        }
    }

    func delete(entity: RMBookmarkEntertainment) -> Observable<Void> {
        return Observable.deferred {
            return self.realmInstance().rx.delete(entity: entity)
        }
    }

    func delete(entities: [RMBookmarkEntertainment]) -> Observable<Void> {
        return Observable.deferred {
            let deleteObs = entities.map { entity in
                return self.realmInstance().rx.delete(entity: entity)
            }
            return Observable.zip(deleteObs)
                .map { _ in }
        }
    }
    
    func deleteAllMovies() -> Observable<Void> {
        return Observable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMBookmarkEntertainment.self)
                .toArray()
                .filter { $0.type == .movie }
            return realm.rx.delete(entities: objects)
        }
    }
    
    func deleteAllTVShows() -> Observable<Void> {
        return Observable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMBookmarkEntertainment.self)
                .toArray()
                .filter { $0.type == .tvShow }
            return realm.rx.delete(entities: objects)
        }
    }
}
