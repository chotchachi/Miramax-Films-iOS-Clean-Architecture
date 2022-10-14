//
//  PeopleApi.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Moya

enum PeopleApi {
    case personDetail(personId: Int)
}

extension PeopleApi: TargetType, NetworkConfigurable {
    var baseURL: URL {
        return baseApiURL
    }
    
    var path: String {
        switch self {
        case .personDetail(personId: let personId):
            return "person/\(personId)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .personDetail:
            return .requestParameters(parameters: ["append_to_response" : "images,combined_credits"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
