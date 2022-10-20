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
    
    func save(entity: RMBookmarkPerson) -> Completable {
        return Completable.deferred {
            return self.realmInstance().rx.save(entity: entity)
        }
    }

    func delete(entity: RMBookmarkPerson) -> Completable {
        return Completable.deferred {
            return self.realmInstance().rx.delete(entity: entity)
        }
    }

    func deleteAll() -> Completable {
        return Completable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMBookmarkPerson.self)
            return realm.rx.delete(entities: objects.toArray())
        }
    }
}
