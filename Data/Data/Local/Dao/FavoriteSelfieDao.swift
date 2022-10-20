//
//  FavoriteSelfieDao.swift
//  Data
//
//  Created by Thanh Quang on 19/10/2022.
//

import RealmSwift
import RxSwift
import RxRealm

final class FavoriteSelfieDao: BaseDao {
    
    required init(config: Realm.Configuration) {
        super.init(config: config)
    }
    
    func queryAll() -> Observable<[RMFavoriteSelfie]> {
        return Observable.deferred {
            let realm = self.realmInstance()
            let objects = realm.objects(RMFavoriteSelfie.self)
            return Observable.array(from: objects)
        }
    }
    
    func save(entity: RMFavoriteSelfie) -> Completable {
        return Completable.deferred {
            return self.realmInstance().rx.save(entity: entity)
        }
    }
}
