//
//  RMBookmarkEntertainment.swift
//  Data
//
//  Created by Thanh Quang on 09/10/2022.
//

import RealmSwift
import Domain

public final class RMBookmarkEntertainment: Object {
    @Persisted(primaryKey: true) var _id: Int = 0
    @Persisted var name: String = ""
    @Persisted var overview: String = ""
    @Persisted var rating: Double = 0.0
    @Persisted var releaseDate: String = ""
    @Persisted var backdropPath: String?
    @Persisted var posterPath: String?
    @Persisted var type: RMEntertainmentType = .movie
    @Persisted var createAt: Date = Date()
}

extension RMBookmarkEntertainment: RMOperator {
    public func primaryKey() -> Int {
        return _id
    }
}

extension RMBookmarkEntertainment: DomainConvertibleType {
    public func asDomain() -> BookmarkEntertainment {
        return BookmarkEntertainment(id: _id, name: name, overview: overview, rating: rating, releaseDate: releaseDate, backdropPath: backdropPath, posterPath: posterPath, type: type.asDomain(), createAt: createAt)
    }
}

extension BookmarkEntertainment: RealmRepresentable {
    public func asRealm() -> RMBookmarkEntertainment {
        return RMBookmarkEntertainment.build { object in
            object._id = id
            object.name = name
            object.overview = overview
            object.rating = rating
            object.releaseDate = releaseDate
            object.backdropPath = backdropPath
            object.posterPath = posterPath
            object.type = type.asRealm()
            object.createAt = createAt
        }
    }
}
