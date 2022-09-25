//
//  BaseDao.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import RealmSwift

class BaseDao {
    private var config: Realm.Configuration

    required init(config: Realm.Configuration) {
        self.config = config
    }
    
    func realmInstance() -> Realm {
        return try! Realm(configuration: config)
    }
}
