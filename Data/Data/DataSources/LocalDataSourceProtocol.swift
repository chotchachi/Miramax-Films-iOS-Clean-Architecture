//
//  LocalDataSourceProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

public protocol LocalDataSourceProtocol {
    func getSearchRecentEntertainments() -> Observable<[RMRecentEntertainment]>
    func saveSearchRecentEntertainments(item: RMRecentEntertainment) -> Observable<Void>
}
