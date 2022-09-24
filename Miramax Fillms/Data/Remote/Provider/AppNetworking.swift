//
//  AppNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Moya
import RxSwift

struct AppNetworking: NetworkingType {
    typealias T = AppApi
    let provider: NetworkProvider<T>
    
    static func getNetworking() -> AppNetworking {
        return AppNetworking(provider: NetworkProvider(session: DefaultAlamofireSession.shared))
    }
}
