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
    private let genreNetworking: GenreNetworking
    private let movieNetworking: MovieNetworking
    private let tvShowNetworking: TVShowNetworking
    private let searchNetworking: SearchNetworking
    
    init(
        genreNetworking: GenreNetworking,
        movieNetworking: MovieNetworking,
        tvShowNetworking: TVShowNetworking,
        searchNetworking: SearchNetworking
    ) {
        self.genreNetworking = genreNetworking
        self.movieNetworking = movieNetworking
        self.tvShowNetworking = tvShowNetworking
        self.searchNetworking = searchNetworking
    }
    
    // MARK: - Genre

    func getGenreMovieList() -> Single<GenreResponseDTO> {
        return genreNetworking.provider.requestObject(.movieGenreList, type: GenreResponseDTO.self)
    }
    
    func getGenreShowList() -> Single<GenreResponseDTO> {
        return genreNetworking.provider.requestObject(.showGenreList, type: GenreResponseDTO.self)
    }
    
    // MARK: - Movie
    
    func getMovieNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.nowPlaying(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    func getMovieTopRated(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.topRated(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    func getMoviePopular(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.popular(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    func getMovieUpcoming(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.upComing(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    func getMovieLatest(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.latest(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    func getMovieByGenre(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.byGenre(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    func searchMovie(query: String, page: Int?) -> Single<MovieResponseDTO> {
        return searchNetworking.provider.requestObject(.searchMovie(query: query, page: page), type: MovieResponseDTO.self)
    }
    
    func getMovieDetail(movieId: Int) -> Single<MovieDetailDTO> {
        return movieNetworking.provider.requestObject(.detail(movieId: movieId), type: MovieDetailDTO.self)
    }
    
    // MARK: - Show

    func getTVShowAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.airingToday(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    func getTVShowOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.onTheAir(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    func getTVShowToprated(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.topRated(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    func getTVShowPopular(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.popular(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    func getTVShowLatest(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.latest(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    func getTVShowByGenre(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.byGenre(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    func searchTVShow(query: String, page: Int?) -> Single<TVShowResponseDTO> {
        return searchNetworking.provider.requestObject(.searchTVShow(query: query, page: page), type: TVShowResponseDTO.self)
    }
    
    func getTVShowDetail(tvShowId: Int) -> Single<TVShowDetailDTO> {
        return tvShowNetworking.provider.requestObject(.detail(tvShowId: tvShowId), type: TVShowDetailDTO.self)
    }
    
    // MARK: - Person
    
    func searchPerson(query: String, page: Int?) -> Single<PersonResponseDTO> {
        return searchNetworking.provider.requestObject(.searchPerson(query: query, page: page), type: PersonResponseDTO.self)
    }
}
