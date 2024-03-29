//
//  PeopleNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Moya
import RxSwift

public struct PeopleNetworking: NetworkingType {
    typealias T = PeopleApi
    let provider: NetworkProvider<T>
    
    public static func getNetworking() -> PeopleNetworking {
        let provider = NetworkProvider<T>(
            endpointClosure: DefaultEndpointMapping().endpointsClosure(),
            session: DefaultAlamofireSession.shared
        )
        return PeopleNetworking(provider: provider)
    }
}
