//
//  Api.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift

protocol Api {
    
    // MARK: - Movie
    
    func getMovieGenreList() -> Single<GenreResponseDTO>
}
