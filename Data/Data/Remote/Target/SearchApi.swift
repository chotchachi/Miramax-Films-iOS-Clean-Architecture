//
//  SearchApi.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Moya

enum SearchApi {
    case searchMovie(query: String, page: Int?)
    case searchTVShow(query: String, page: Int?)
    case searchPerson(query: String, page: Int?)
}

extension SearchApi: TargetType, NetworkConfigurable {
    var baseURL: URL {
        return baseApiURL
    }
    
    var path: String {
        switch self {
        case .searchMovie:
            return "search/movie"
        case .searchTVShow:
            return "search/tv"
        case .searchPerson:
            return "search/person"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .searchMovie(query: let query, page: let page):
            return requestWithQueryAndPageTask(query, page)
        case .searchTVShow(query: let query, page: let page):
            return requestWithQueryAndPageTask(query, page)
        case .searchPerson(query: let query, page: let page):
            return requestWithQueryAndPageTask(query, page)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    private func requestWithQueryAndPageTask(_ query: String, _ page: Int?) -> Moya.Task {
        var params: [String : Any] = [
            "api_key" : apiKey
        ]
        params["query"] = query
        if page != nil {
            params["page"] = page
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
}
