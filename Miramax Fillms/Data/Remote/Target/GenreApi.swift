//
//  GenreApi.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Moya

enum GenreApi {
    case movieGenreList
    case showGenreList
}

extension GenreApi: TargetType {
    var apiKey: String {
        return NetworkConfiguration.shared.apiKey
    }
    
    var baseURL: URL {
        NetworkConfiguration.shared.baseAPIURL
    }
    
    var path: String {
        switch self {
        case .movieGenreList:
            return "genre/movie/list"
        case .showGenreList:
            return "genre/tv/list"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        .requestParameters(parameters: ["api_key" : apiKey], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        nil
    }
}
