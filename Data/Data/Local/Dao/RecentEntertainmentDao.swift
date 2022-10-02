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
    
    func save(entity: RMRecentEntertainment) -> Observable<Void> {
        return Observable.deferred {
            return self.realmInstance().rx.save(entity: entity)
        }
    }

    func update(entity: RMRecentEntertainment) -> Observable<Void> {
        return Observable.deferred {
            return self.realmInstance().rx.save(entity: entity, update: true)
        }
    }

    func delete(entity: RMRecentEntertainment) -> Observable<Void> {
        return Observable.deferred {
            return self.realmInstance().rx.delete(entity: entity)
        }
    }

    func delete(entities: [RMRecentEntertainment]) -> Observable<Void> {
        return Observable.deferred {
            let deleteObs = entities.map { entity in
                return self.realmInstance().rx.delete(entity: entity)
            }
            return Observable.zip(deleteObs)
                .map { _ in }
        }
    }
}
