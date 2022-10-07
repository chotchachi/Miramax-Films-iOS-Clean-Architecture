//
//  RMTVShow.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import RealmSwift
import Domain

public final class RMTVShow: Object {
    @Persisted(primaryKey: true) var _id: Int = 0
    @Persisted var name: String = ""
    @Persisted var overview: String = ""
    @Persisted var voteAverage: Double = 0.0
    @Persisted var firstAirDate: String = ""
    @Persisted var backdropPath: String?
    @Persisted var posterPath: String?
}

extension RMTVShow: DomainConvertibleType {
    public func asDomain() -> TVShow {
        return TVShow(id: _id, name: name, overview: overview, voteAverage: voteAverage, firstAirDate: firstAirDate, backdropPath: backdropPath, posterPath: posterPath, genres: nil, numberOfEpisodes: nil, numberOfSeasons: nil, seasons: nil, credits: nil, recommendations: nil)
    }
}

extension TVShow: RealmRepresentable {
    public func asRealm() -> RMTVShow {
        return RMTVShow.build { object in
            object._id = id
            object.name = name
            object.overview = overview
            object.voteAverage = voteAverage
            object.firstAirDate = firstAirDate
            object.backdropPath = backdropPath
            object.posterPath = posterPath
        }
    }
}
