//
//  NetworkProvider.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import Moya
import RxSwift
import ObjectMapper

class NetworkProvider<Target> where Target: TargetType {
    fileprivate let online: Observable<Bool>
    fileprivate let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         online: Observable<Bool> = connectedToInternet()) {
        
        self.online = online
        self.provider = MoyaProvider(endpointClosure: endpointClosure,
                                     requestClosure: requestClosure,
                                     stubClosure: stubClosure,
                                     session: session,
                                     plugins: plugins,
                                     trackInflights: trackInflights)
    }
    
    private func request(_ token: Target) -> Single<Moya.Response> {
        return provider.rx.request(token)
    }
}

// MARK: - Base Request Method Helpers

extension NetworkProvider where Target: TargetType {
    func request(_ target: Target) -> Single<Any> {
        return request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
    }
    
    func requestWithoutMapping(_ target: Target) -> Single<Response> {
        return request(target)
            .filterSuccessfulStatusAndRedirectCodes()
    }
    
    func requestObject<T: BaseMappable>(_ target: Target, type: T.Type) -> Single<T> {
        return request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
            .map { Mapper<T>().map(JSONObject: $0) }
            .flatMap {
                if let map = $0 {
                    return Single.just(map)
                } else {
                    return Single.error(NSError(domain: "Map object failed", code: 1, userInfo: nil))
                }
            }
    }
    
    func requestObjects<T: BaseMappable>(_ target: Target, type: T.Type) -> Single<[T]> {
        return request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
            .map { Mapper<T>().mapArray(JSONObject: $0) }
            .flatMap {
                if let map = $0 {
                    return Single.just(map)
                } else {
                    return Single.error(NSError(domain: "Map object failed", code: 1, userInfo: nil))
                }
            }
    }
    
}
