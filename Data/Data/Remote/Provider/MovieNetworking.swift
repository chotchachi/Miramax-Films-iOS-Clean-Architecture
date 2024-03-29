//
//  MovieNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Moya
import RxSwift

public struct MovieNetworking: NetworkingType {
    typealias T = MovieApi
    let provider: NetworkProvider<T>
    
    public static func getNetworking() -> MovieNetworking {
        let provider = NetworkProvider<T>(
            endpointClosure: DefaultEndpointMapping().endpointsClosure(),
            session: DefaultAlamofireSession.shared
        )
        return MovieNetworking(provider: provider)
    }
}
