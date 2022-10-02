//
//  TVShowNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Moya
import RxSwift

public struct TVShowNetworking: NetworkingType {
    typealias T = TVShowApi
    let provider: NetworkProvider<T>
    
    public static func getNetworking() -> TVShowNetworking {
        return TVShowNetworking(provider: NetworkProvider(session: DefaultAlamofireSession.shared))
    }
}
