//
//  RMRecentEntertainment.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import RealmSwift
import Domain

public final class RMRecentEntertainment: Object {
    @Persisted(primaryKey: true) var _id: Int = 0
    @Persisted var name: String = ""
    @Persisted var backdropPath: String?
    @Persisted var posterPath: String?
    @Persisted var type: RMEntertainmentType = .movie
    @Persisted var createAt: Date = Date()
}

extension RMRecentEntertainment: RMOperator {
    public func primaryKey() -> Int {
        return _id
    }
}

extension RMRecentEntertainment: DomainConvertibleType {
    public func asDomain() -> RecentEntertainment {
        return RecentEntertainment(
            id: _id,
            name: name,
            backdropPath: backdropPath,
            posterPath: posterPath,
            type: type.asDomain(),
            createAt: createAt
        )
    }
}

extension RecentEntertainment: RealmRepresentable {
    public func asRealm() -> RMRecentEntertainment {
        return RMRecentEntertainment.build { object in
            object._id = id
            object.name = name
            object.backdropPath = backdropPath
            object.posterPath = posterPath
            object.type = type.asRealm()
            object.createAt = createAt
        }
    }
}
