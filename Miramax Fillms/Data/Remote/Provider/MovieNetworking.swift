//
//  MovieNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Moya
import RxSwift

struct MovieNetworking: NetworkingType {
    typealias T = MovieApi
    let provider: NetworkProvider<T>
    
    static func getNetworking() -> MovieNetworking {
        return MovieNetworking(provider: NetworkProvider(session: DefaultAlamofireSession.shared))
    }
}
