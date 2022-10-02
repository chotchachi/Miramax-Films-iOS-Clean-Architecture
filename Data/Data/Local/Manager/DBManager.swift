//
//  DBManager.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import RealmSwift

public final class DBManager {
    private let SCHEMA_VERSION: UInt64 = 1
    private let realmConfig: Realm.Configuration
    private var daoCached = [String: BaseDao]()

    public init() {
        realmConfig = Realm.Configuration(schemaVersion: SCHEMA_VERSION)
        Realm.Configuration.defaultConfiguration = realmConfig
    }
    
    func getDao<T : BaseDao>(_: T.Type) -> T {
        let key = String(describing: T.self)
        if let dao = daoCached[key] as? T {
            return dao
        }
        
        let dao = T(config: realmConfig)
        daoCached[key] = dao
        return dao
    }
}
