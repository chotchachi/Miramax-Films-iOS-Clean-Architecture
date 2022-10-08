//
//  RemoteDataSource.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

public final class RemoteDataSource: RemoteDataSourceProtocol {
    private let apiClient: Api
    
    public init(apiClient: Api, apiKey: String) {
        self.apiClient = apiClient
        NetworkConfiguration.shared.configure(with: apiKey)
    }
    
    public func getGenreMovieList() -> Single<GenreResponseDTO> {
        return apiClient.getGenreMovieList()
    }
    
    public func getGenreShowList() -> Single<GenreResponseDTO> {
        return apiClient.getGenreShowList()
    }
    
    public func getMovieNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieNowPlaying(genreId: genreId, page: page)
    }
    
    public func getMovieTopRated(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieTopRated(genreId: genreId, page: page)
    }
    
    public func getMoviePopular(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMoviePopular(genreId: genreId, page: page)
    }
    
    public func getMovieUpcoming(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieUpcoming(genreId: genreId, page: page)
    }
    
    public func getMovieByGenre(genreId: Int, sortBy: String, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieByGenre(genreId: genreId, sortBy: sortBy, page: page)
    }
    
    public func getMovieDetail(movieId: Int) -> Single<MovieDTO> {
        return apiClient.getMovieDetail(movieId: movieId)
    }
    
    public func getMovieRecommendations(movieId: Int, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieRecommendations(movieId: movieId, page: page)
    }
    
    public func getTVShowAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowAiringToday(genreId: genreId, page: page)
    }
    
    public func getTVShowOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowOnTheAir(genreId: genreId, page: page)
    }
    
    public func getTVShowTopRated(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowToprated(genreId: genreId, page: page)
    }
    
    public func getTVShowPopular(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowPopular(genreId: genreId, page: page)
    }
    
    public func getTVShowByGenre(genreId: Int, sortBy: String, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowByGenre(genreId: genreId, sortBy: sortBy, page: page)
    }
    
    public func getTVShowDetail(tvShowId: Int) -> Single<TVShowDTO> {
        return apiClient.getTVShowDetail(tvShowId: tvShowId)
    }
    
    public func getTVShowRecommendations(tvShowId: Int, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowRecommendations(tvShowId: tvShowId, page: page)
    }
    
    public func getTVShowSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<SeasonDTO> {
        return apiClient.getTVSeasonDetails(tvShowId: tvShowId, seasonNumber: seasonNumber)
    }
    
    public func searchMovie(query: String, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.searchMovie(query: query, page: page)
    }
    
    public func searchTVShow(query: String, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.searchTVShow(query: query, page: page)
    }
    
    public func searchPerson(query: String, page: Int?) -> Single<PersonResponseDTO> {
        return apiClient.searchPerson(query: query, page: page)
    }
    
    public func getPersonDetail(persondId: Int) -> Single<PersonDTO> {
        return apiClient.getPersonDetail(personId: persondId)
    }
}
