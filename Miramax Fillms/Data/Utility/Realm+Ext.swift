//
//  Realm+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 23/09/2022.
//

import RealmSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> () ) -> O {
        let object = O()
        builder(object)
        return object
    }
}
