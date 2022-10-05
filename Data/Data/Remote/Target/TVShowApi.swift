//
//  TVShowApi.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Moya

enum TVShowApi {
    case airingToday(genreId: Int?, page: Int?)
    case onTheAir(genreId: Int?, page: Int?)
    case topRated(genreId: Int?, page: Int?)
    case popular(genreId: Int?, page: Int?)
    case byGenre(genreId: Int?, page: Int?)
    case detail(tvShowId: Int)
    case season(tvShowId: Int, seasonNumber: Int)
}

extension TVShowApi: TargetType, NetworkConfigurable {
    var baseURL: URL {
        return baseApiURL
    }
    
    var path: String {
        switch self {
        case .airingToday:
            return "tv/airing_today"
        case .onTheAir:
            return "tv/on_the_air"
        case .topRated:
            return "tv/top_rated"
        case .popular:
            return "tv/popular"
        case .byGenre:
            return "discover/tv"
        case .detail(tvShowId: let tvShowId):
            return "tv/\(tvShowId)"
        case .season(tvShowId: let tvShowId, seasonNumber: let seasonNumber):
            return "tv/\(tvShowId)/season/\(seasonNumber)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .airingToday(genreId: let genreId, page: let page):
            return requestWithGenreIdAndPageTask(genreId, page)
        case .onTheAir(genreId: let genreId, page: let page):
            return requestWithGenreIdAndPageTask(genreId, page)
        case .topRated(genreId: let genreId, page: let page):
            return requestWithGenreIdAndPageTask(genreId, page)
        case .popular(genreId: let genreId, page: let page):
            return requestWithGenreIdAndPageTask(genreId, page)
        case .byGenre(genreId: let genreId, page: let page):
            return requestWithGenreIdAndPageTask(genreId, page)
        case .detail:
            return requestTvShowDetail()
        case .season:
            return requestTvShowSeason()
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    private func requestWithGenreIdAndPageTask(_ genreId: Int?, _ page: Int?) -> Moya.Task {
        var params: [String : Any] = [
            "api_key" : apiKey
        ]
        if genreId != nil {
            params["with_genres"] = genreId
        }
        if page != nil {
            params["page"] = page
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    private func requestTvShowDetail() -> Moya.Task {
        let params: [String : Any] = [
            "api_key" : apiKey,
            "append_to_response" : "credits,recommendations"
        ]
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    private func requestTvShowSeason() -> Moya.Task {
        let params: [String : Any] = [
            "api_key" : apiKey,
        ]
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
}
