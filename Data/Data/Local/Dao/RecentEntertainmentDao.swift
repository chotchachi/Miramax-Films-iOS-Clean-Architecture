//
//  RecentEntertainmentDao.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import RealmSwift
import RxSwift
import RxRealm

final class RecentEntertainmentDao: BaseDao {
    
    required init(config: Realm.Configuration) {
        super.init(config: config)
    }
    
    func queryAll() -> Observable<[RMRecentEntertainment]> {
        return Observable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMRecentEntertainment.self)
            return Observable.array(from: objects)
        }
    }
    
    func save(entity: RMRecentEntertainment) -> Completable {
        return Completable.deferred {
            return self.realmInstance().rx.save(entity: entity)
        }
    }

    func deleteAll() -> Completable {
        return Completable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMRecentEntertainment.self)
            return realm.rx.delete(entities: objects.toArray())
        }
    }
}
