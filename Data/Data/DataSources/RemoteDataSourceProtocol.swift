//
//  RemoteDataSourceProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

public protocol RemoteDataSourceProtocol {
    func getGenreMovieList() -> Single<GenreResponseDTO>
    func getGenreShowList() -> Single<GenreResponseDTO>
    
    func getMovieNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieTopRated(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMoviePopular(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieUpcoming(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieByGenre(genreId: Int, sortBy: String, page: Int?) -> Single<MovieResponseDTO>
    func getMovieDetail(movieId: Int) -> Single<MovieDTO>
    func getMovieRecommendations(movieId: Int, page: Int?) -> Single<MovieResponseDTO>

    func getTVShowAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowTopRated(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowPopular(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowByGenre(genreId: Int, sortBy: String, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowDetail(tvShowId: Int) -> Single<TVShowDTO>
    func getTVShowRecommendations(tvShowId: Int, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<SeasonDTO>

    func searchMovie(query: String, page: Int?) -> Single<MovieResponseDTO>
    func searchTVShow(query: String, page: Int?) -> Single<TVShowResponseDTO>
    func searchPerson(query: String, page: Int?) -> Single<PersonResponseDTO>
    
    func getPersonDetail(persondId: Int) -> Single<PersonDTO>
}
