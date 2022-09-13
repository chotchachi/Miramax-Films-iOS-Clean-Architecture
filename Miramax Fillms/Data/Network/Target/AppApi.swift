//
//  AppApi.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import Moya

enum AppApi {
    case movieGenreList
}

extension AppApi: TargetType {
    var baseURL: URL {
        let urlString = "https://api.themoviedb.org/3"
        guard let url = URL(string: urlString) else { fatalError("Base URL Invalid") }
        return url
    }
    
    var path: String {
        switch self {
        case .movieGenreList:
            return "genre/movie/list"
        }
    }
    
    var method: Method {
        switch self {
        case .movieGenreList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .movieGenreList:
            return .requestParameters(parameters: ["api_key" : "9f7ceb7615afe6f16274a953ad31c29e"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
