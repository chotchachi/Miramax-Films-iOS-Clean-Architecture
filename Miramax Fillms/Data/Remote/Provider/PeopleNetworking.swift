//
//  PeopleNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Moya
import RxSwift

struct PeopleNetworking: NetworkingType {
    typealias T = PeopleApi
    let provider: NetworkProvider<T>
    
    static func getNetworking() -> PeopleNetworking {
        return PeopleNetworking(provider: NetworkProvider(session: DefaultAlamofireSession.shared))
    }
}
