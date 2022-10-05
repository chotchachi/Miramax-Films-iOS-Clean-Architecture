//
//  Api.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift

public protocol Api {
    
    // MARK: - Genre
    
    func getGenreMovieList() -> Single<GenreResponseDTO>
    func getGenreShowList() -> Single<GenreResponseDTO>

    // MARK: - Movie
    
    func getMovieNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieTopRated(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMoviePopular(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieUpcoming(genreId: Int?, page: Int?) -> Single<MovieResponseDTO>
    func getMovieByGenre(genreId: Int, page: Int?) -> Single<MovieResponseDTO>
    func getMovieDetail(movieId: Int) -> Single<MovieDetailDTO>
    func getMovieRecommendations(movieId: Int, page: Int?) -> Single<MovieResponseDTO>

    // MARK: - TV
    
    func getTVShowAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowToprated(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowPopular(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowByGenre(genreId: Int, page: Int?) -> Single<TVShowResponseDTO>
    func getTVShowDetail(tvShowId: Int) -> Single<TVShowDetailDTO>
    func getTVShowRecommendations(tvShowId: Int, page: Int?) -> Single<TVShowResponseDTO>

    // MARK: - TV Season
    
    func getTVSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<SeasonDTO>
    
    // MARK: - Search
    
    func searchMovie(query: String, page: Int?) -> Single<MovieResponseDTO>
    func searchTVShow(query: String, page: Int?) -> Single<TVShowResponseDTO>
    func searchPerson(query: String, page: Int?) -> Single<PersonResponseDTO>

    // MARK: - Person
    
    func getPersonDetail(personId: Int) -> Single<PersonDetailDTO>
}
