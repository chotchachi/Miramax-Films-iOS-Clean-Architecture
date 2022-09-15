//
//  GenreNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Moya
import RxSwift

struct GenreNetworking: NetworkingType {
    typealias T = GenreApi
    let provider: NetworkProvider<T>
    
    static func getNetworking() -> GenreNetworking {
        return GenreNetworking(provider: NetworkProvider(session: DefaultAlamofireSession.shared))
    }
}
