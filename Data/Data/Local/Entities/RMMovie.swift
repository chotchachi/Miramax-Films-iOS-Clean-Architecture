//
//  RMMovie.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 23/09/2022.
//

import RealmSwift
import Domain

public final class RMMovie: Object {
    @Persisted(primaryKey: true) var _id: Int = 0
    @Persisted var title: String = ""
    @Persisted var backdropPath: String?
    @Persisted var posterPath: String?
    @Persisted var overview: String = ""
    @Persisted var voteAverage: Double = 0.0
    @Persisted var releaseDate: String = ""
}

extension RMMovie: DomainConvertibleType {
    public func asDomain() -> Movie {
        return Movie(
            id: _id,
            title: title,
            backdropPath: backdropPath,
            posterPath: posterPath,
            overview: overview,
            voteAverage: voteAverage,
            releaseDate: releaseDate
        )
    }
}

extension Movie: RealmRepresentable {
    public func asRealm() -> RMMovie {
        return RMMovie.build { object in
            object._id = id
            object.title = title
            object.backdropPath = backdropPath
            object.posterPath = posterPath
            object.overview = overview
            object.voteAverage = voteAverage
            object.releaseDate = releaseDate
        }
    }
}
