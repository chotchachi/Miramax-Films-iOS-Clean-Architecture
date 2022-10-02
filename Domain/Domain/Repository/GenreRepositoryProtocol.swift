//
//  GenreRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

public protocol GenreRepositoryProtocol {
    func getGenreMovieList() -> Single<[Genre]>
    func getGenreShowList() -> Single<[Genre]>
}
