//
//  MovieApi.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Moya

enum MovieApi {
    case nowPlaying(genreId: Int?, page: Int?)
    case topRated(genreId: Int?, page: Int?)
    case popular(genreId: Int?, page: Int?)
    case upComing(genreId: Int?, page: Int?)
    case byGenre(genreId: Int, sortBy: String, page: Int?)
    case detail(movieId: Int)
    case recommendations(movieId: Int, page: Int?)
}

extension MovieApi: TargetType, NetworkConfigurable {
    var baseURL: URL {
        return baseApiURL
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "movie/now_playing"
        case .topRated:
            return "movie/top_rated"
        case .popular:
            return "movie/popular"
        case .upComing:
            return "movie/upcoming"
        case .byGenre:
            return "discover/movie"
        case .detail(movieId: let movieId):
            return "movie/\(movieId)"
        case .recommendations(movieId: let movieId, page: _):
            return "movie/\(movieId)/recommendations"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .nowPlaying(genreId: let genreId, page: let page):
            return requestWithParams(genreId: genreId, page: page)
        case .topRated(genreId: let genreId, page: let page):
            return requestWithParams(genreId: genreId, page: page)
        case .popular(genreId: let genreId, page: let page):
            return requestWithParams(genreId: genreId, page: page)
        case .upComing(genreId: let genreId, page: let page):
            return requestWithParams(genreId: genreId, page: page)
        case .byGenre(genreId: let genreId, sortBy: let sortBy, page: let page):
            return requestWithParams(genreId: genreId, sortBy: sortBy, page: page)
        case .detail:
            return .requestParameters(parameters: ["append_to_response" : "credits,recommendations,images,videos"], encoding: URLEncoding.default)
        case .recommendations(movieId: _, page: let page):
            return requestWithParams(page: page)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    private func requestWithParams(genreId: Int? = nil, sortBy: String? = nil, page: Int? = nil) -> Moya.Task {
        var params: [String : Any] = [:]
        if genreId != nil {
            params["with_genres"] = genreId
        }
        if sortBy != nil {
            params["sort_by"] = sortBy
        }
        if page != nil {
            params["page"] = page
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
}
