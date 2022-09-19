//
//  RemoteDataSource.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

final class RemoteDataSource: RemoteDataSourceProtocol {
    private let apiClient: Api
    
    init(apiClient: Api) {
        self.apiClient = apiClient
    }
    
    func getGenreMovieList() -> Single<GenreResponseDTO> {
        return apiClient.getGenreMovieList()
    }
    
    func getGenreShowList() -> Single<GenreResponseDTO> {
        return apiClient.getGenreShowList()
    }
    
    func getMovieNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieNowPlaying(genreId: genreId, page: page)
    }
    
    func getMovieTopRated(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieTopRated(genreId: genreId, page: page)
    }
    
    func getMoviePopular(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMoviePopular(genreId: genreId, page: page)
    }
    
    func getMovieUpcoming(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieUpcoming(genreId: genreId, page: page)
    }
    
    func getMovieLatest(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieLatest(genreId: genreId, page: page)
    }
    
    func getMovieByGenre(genreId: Int?, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.getMovieByGenre(genreId: genreId, page: page)
    }
    
    func searchMovie(query: String, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.searchMovie(query: query, page: page)
    }
    
    func getMovieDetail(movieId: Int) -> Single<MovieDetailDTO> {
        return apiClient.getMovieDetail(movieId: movieId)
    }
    
    func getTVShowAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowAiringToday(genreId: genreId, page: page)
    }
    
    func getTVShowOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowOnTheAir(genreId: genreId, page: page)
    }
    
    func getTVShowTopRated(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowToprated(genreId: genreId, page: page)
    }
    
    func getTVShowPopular(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowPopular(genreId: genreId, page: page)
    }
    
    func getTVShowLatest(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowLatest(genreId: genreId, page: page)
    }
    
    func getTVShowByGenre(genreId: Int?, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.getTVShowByGenre(genreId: genreId, page: page)
    }
    
    func searchTVShow(query: String, page: Int?) -> Single<TVShowResponseDTO> {
        return apiClient.searchTVShow(query: query, page: page)
    }
    
    func getTVShowDetail(tvShowId: Int) -> Single<TVShowDetailDTO> {
        return apiClient.getTVShowDetail(tvShowId: tvShowId)
    }
    
    func searchPerson(query: String, page: Int?) -> Single<PersonResponseDTO> {
        return apiClient.searchPerson(query: query, page: page)
    }
}
