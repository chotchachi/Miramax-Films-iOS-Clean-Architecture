//
//  RemoteDataSourceProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

protocol RemoteDataSourceProtocol {
    func getGenreMovieList() -> Single<GenreResponseDTO>
    func getGenreShowList() -> Single<GenreResponseDTO>
    
    func getMovieNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieTopRated(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMoviePopular(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieUpcoming(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieLatest(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieByGenre(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieDetail(movieId: Int) -> Single<MovieDetailDTO>
    
    func getTVShowAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowTopRated(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowPopular(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowLatest(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowByGenre(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowDetail(tvShowId: Int) -> Single<TVShowDetailDTO>
    func getTVShowSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<SeasonDTO>

    func searchMovie(query: String, page: Int?) -> Single<MovieResponseDTO>
    func searchTVShow(query: String, page: Int?) -> Single<TVShowResponseDTO>
    func searchPerson(query: String, page: Int?) -> Single<PersonResponseDTO>
}
