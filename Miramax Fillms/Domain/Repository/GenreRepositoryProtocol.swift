//
//  GenreRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

protocol GenreRepositoryProtocol {
    func getGenreMovieList() -> Single<GenreResponse>
    func getGenreShowList() -> Single<GenreResponse>
}
