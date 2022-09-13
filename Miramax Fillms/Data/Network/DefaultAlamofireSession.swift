//
//  DefaultAlamofireSession.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import Alamofire
import Moya

class DefaultAlamofireSession: Session {
    static let shared: DefaultAlamofireSession = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 30.0 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 30.0 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireSession(configuration: configuration, startRequestsImmediately: false)
    }()
}
