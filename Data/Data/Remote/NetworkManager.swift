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

public final class NetworkManager: Api {
    private let genreNetworking: GenreNetworking
    private let movieNetworking: MovieNetworking
    private let tvShowNetworking: TVShowNetworking
    private let searchNetworking: SearchNetworking
    private let peopleNetworking: PeopleNetworking
    
    public init(genreNetworking: GenreNetworking, movieNetworking: MovieNetworking, tvShowNetworking: TVShowNetworking, searchNetworking: SearchNetworking, peopleNetworking: PeopleNetworking) {
        self.genreNetworking = genreNetworking
        self.movieNetworking = movieNetworking
        self.tvShowNetworking = tvShowNetworking
        self.searchNetworking = searchNetworking
        self.peopleNetworking = peopleNetworking
    }
    
    // MARK: - Genre

    public func getGenreMovieList() -> Single<GenreResponseDTO> {
        return genreNetworking.provider.requestObject(.movieGenreList, type: GenreResponseDTO.self)
    }
    
    public func getGenreShowList() -> Single<GenreResponseDTO> {
        return genreNetworking.provider.requestObject(.showGenreList, type: GenreResponseDTO.self)
    }
    
    // MARK: - Movie
    
    public func getMovieNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.nowPlaying(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    public func getMovieTopRated(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.topRated(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    public func getMoviePopular(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.popular(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    public func getMovieUpcoming(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.upComing(genreId: genreId, page: page), type: MovieResponseDTO.self)
    }
    
    public func getMovieByGenre(genreId: Int, sortBy: String, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.byGenre(genreId: genreId, sortBy: sortBy, page: page), type: MovieResponseDTO.self)
    }
    
    public func getMovieDetail(movieId: Int) -> Single<MovieDTO> {
        return movieNetworking.provider.requestObject(.detail(movieId: movieId), type: MovieDTO.self)
    }
    
    public func getMovieRecommendations(movieId: Int, page: Int?) -> Single<MovieResponseDTO> {
        return movieNetworking.provider.requestObject(.recommendations(movieId: movieId, page: page), type: MovieResponseDTO.self)
    }
    
    // MARK: - Show

    public func getTVShowAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.airingToday(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    public func getTVShowOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.onTheAir(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    public func getTVShowToprated(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.topRated(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    public func getTVShowPopular(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.popular(genreId: genreId, page: page), type: TVShowResponseDTO.self)
    }
    
    public func getTVShowByGenre(genreId: Int, sortBy: String, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.byGenre(genreId: genreId, sortBy: sortBy, page: page), type: TVShowResponseDTO.self)
    }
    
    public func getTVShowDetail(tvShowId: Int) -> Single<TVShowDTO> {
        return tvShowNetworking.provider.requestObject(.detail(tvShowId: tvShowId), type: TVShowDTO.self)
    }
    
    public func getTVShowRecommendations(tvShowId: Int, page: Int?) -> Single<TVShowResponseDTO> {
        return tvShowNetworking.provider.requestObject(.recommendations(tvShowId: tvShowId, page: page), type: TVShowResponseDTO.self)
    }
    
    // MARK: - TV Season
    
    public func getTVSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<SeasonDTO> {
        return tvShowNetworking.provider.requestObject(.season(tvShowId: tvShowId, seasonNumber: seasonNumber), type: SeasonDTO.self)
    }
    
    // MARK: - Search
    
    public func searchMovie(query: String, page: Int?) -> Single<MovieResponseDTO> {
        return searchNetworking.provider.requestObject(.searchMovie(query: query, page: page), type: MovieResponseDTO.self)
    }

    public func searchTVShow(query: String, page: Int?) -> Single<TVShowResponseDTO> {
        return searchNetworking.provider.requestObject(.searchTVShow(query: query, page: page), type: TVShowResponseDTO.self)
    }
    
    public func searchPerson(query: String, page: Int?) -> Single<PersonResponseDTO> {
        return searchNetworking.provider.requestObject(.searchPerson(query: query, page: page), type: PersonResponseDTO.self)
    }
    
    // MARK: - Person
    
    public func getPersonDetail(personId: Int) -> Single<PersonDTO> {
        return peopleNetworking.provider.requestObject(.personDetail(personId: personId), type: PersonDTO.self)
    }
}
