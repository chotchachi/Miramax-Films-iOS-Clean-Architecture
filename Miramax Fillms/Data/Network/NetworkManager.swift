//
//  NetworkManager.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift
import Moya
import Alamofire
import ObjectMapper

final class NetworkManager: Api {
    
    private let appNetworking: AppNetworking
    
    init(appNetworking: AppNetworking) {
        self.appNetworking = appNetworking
    }
    
    func getMovieGenreList() -> Single<GenreResponseDTO> {
        return requestObject(.movieGenreList, type: GenreResponseDTO.self)
    }
}

// MARK: - Base Request Method Helpers

extension NetworkManager {
    private func request(_ target: AppApi) -> Single<Any> {
        return appNetworking.request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
    }
    
    private func requestWithoutMapping(_ target: AppApi) -> Single<Response> {
        return appNetworking.request(target)
            .filterSuccessfulStatusAndRedirectCodes()
    }
    
    private func requestObject<T: BaseMappable>(_ target: AppApi, type: T.Type) -> Single<T> {
        return appNetworking.request(target)
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
    
    private func requestObjects<T: BaseMappable>(_ target: AppApi, type: T.Type) -> Single<[T]> {
        return appNetworking.request(target)
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
