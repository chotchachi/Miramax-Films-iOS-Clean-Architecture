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
        let provider = NetworkProvider<T>(
            endpointClosure: DefaultEndpointMapping().endpointsClosure(),
            session: DefaultAlamofireSession.shared
        )
        return TVShowNetworking(provider: provider)
    }
}
