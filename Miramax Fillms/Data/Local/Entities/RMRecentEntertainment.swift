//
//  RMRecentEntertainment.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import RealmSwift

final class RMRecentEntertainment: Object {
    @Persisted(primaryKey: true) var _id: Int = 0
    @Persisted var name: String = ""
    @Persisted var posterPath: String?
    @Persisted var type: RMEntertainmentType = .movie
}

extension RMRecentEntertainment: RMOperator {
    func primaryKey() -> Int {
        return _id
    }
}

extension RMRecentEntertainment: DomainConvertibleType {
    func asDomain() -> RecentEntertainment {
        return RecentEntertainment(
            id: _id,
            name: name,
            posterPath: posterPath,
            type: type.asDomain()
        )
    }
}

extension RecentEntertainment: RealmRepresentable {
    func asRealm() -> RMRecentEntertainment {
        return RMRecentEntertainment.build { object in
            object._id = id
            object.name = name
            object.posterPath = posterPath
        }
    }
}
