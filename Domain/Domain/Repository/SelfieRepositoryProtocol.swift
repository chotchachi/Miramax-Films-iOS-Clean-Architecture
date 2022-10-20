//
//  SelfieRepositoryProtocol.swift
//  Domain
//
//  Created by Thanh Quang on 15/10/2022.
//

import RxSwift

public protocol SelfieRepositoryProtocol {
    func getAllFrame() -> [SelfieFrame]
    func getAllFavoriteSelfie() -> Observable<[FavoriteSelfie]>
    func saveFavoriteSelfie(item: FavoriteSelfie) -> Completable
}
