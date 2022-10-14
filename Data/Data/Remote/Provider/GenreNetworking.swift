//
//  GenreNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Moya
import RxSwift

public struct GenreNetworking: NetworkingType {
    typealias T = GenreApi
    let provider: NetworkProvider<T>
    
    public static func getNetworking() -> GenreNetworking {
        let provider = NetworkProvider<T>(
            endpointClosure: DefaultEndpointMapping().endpointsClosure(),
            session: DefaultAlamofireSession.shared
        )
        return GenreNetworking(provider: provider)
    }
}
