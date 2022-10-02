//
//  SearchNetworking.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Moya
import RxSwift

public struct SearchNetworking: NetworkingType {
    typealias T = SearchApi
    let provider: NetworkProvider<T>
    
    public static func getNetworking() -> SearchNetworking {
        return SearchNetworking(provider: NetworkProvider(session: DefaultAlamofireSession.shared))
    }
}
