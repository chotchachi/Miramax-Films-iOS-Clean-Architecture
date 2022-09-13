//
//  AppNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import Moya
import RxSwift

struct AppNetworking: NetworkingType {
    typealias T = AppApi
    let provider: NetworkProvider<T>
    
    static func getNetworking() -> AppNetworking {
        return AppNetworking(provider: NetworkProvider(session: DefaultAlamofireSession.shared))
    }
    
    func request(_ token: T) -> Single<Moya.Response> {
        return self.provider.request(token)
    }
}
