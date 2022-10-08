//
//  BookmarkPersonDao.swift
//  Data
//
//  Created by Thanh Quang on 08/10/2022.
//

import RealmSwift
import RxSwift
import RxRealm

final class BookmarkPersonDao: BaseDao {
    
    required init(config: Realm.Configuration) {
        super.init(config: config)
    }
    
    func queryAll() -> Observable<[RMBookmarkPerson]> {
        return Observable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMBookmarkPerson.self)
            return Observable.array(from: objects)
        }
    }
    
    func save(entity: RMBookmarkPerson) -> Observable<Void> {
        return Observable.deferred {
            return self.realmInstance().rx.save(entity: entity)
        }
    }

    func update(entity: RMBookmarkPerson) -> Observable<Void> {
        return Observable.deferred {
            return self.realmInstance().rx.save(entity: entity, update: true)
        }
    }

    func delete(entity: RMBookmarkPerson) -> Observable<Void> {
        return Observable.deferred {
            return self.realmInstance().rx.delete(entity: entity)
        }
    }

    func delete(entities: [RMBookmarkPerson]) -> Observable<Void> {
        return Observable.deferred {
            let deleteObs = entities.map { entity in
                return self.realmInstance().rx.delete(entity: entity)
            }
            return Observable.zip(deleteObs)
                .map { _ in }
        }
    }
    
    func deleteAll() -> Observable<Void> {
        return Observable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMBookmarkPerson.self)
            return realm.rx.delete(entities: objects.toArray())
        }
    }
}
