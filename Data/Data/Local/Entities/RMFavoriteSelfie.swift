//
//  RMFavoriteSelfie.swift
//  Data
//
//  Created by Thanh Quang on 19/10/2022.
//

import Foundation
import RealmSwift
import Domain

public final class RMFavoriteSelfie: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var frame: String?
    @Persisted var userLocation: String?
    @Persisted var userCreateDate: Date?
    @Persisted var createAt: Date = Date()
}

extension RMFavoriteSelfie: RMOperator {
    public func primaryKey() -> String {
        return id
    }
}

extension RMFavoriteSelfie: DomainConvertibleType {
    public func asDomain() -> FavoriteSelfie {
        return FavoriteSelfie(id: id, name: name, frame: frame, userLocation: userLocation, userCreateDate: userCreateDate, createAt: createAt)
    }
}

extension FavoriteSelfie: RealmRepresentable {
    public func asRealm() -> RMFavoriteSelfie {
        return RMFavoriteSelfie.build { object in
            object.name = name
            object.frame = frame
            object.userLocation = userLocation
            object.userCreateDate = userCreateDate
            object.createAt = createAt
        }
    }
}
