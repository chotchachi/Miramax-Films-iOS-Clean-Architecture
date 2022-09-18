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
    
    func searchTVShow(query: String, page: Int?) -> Single<MovieResponseDTO> {
        return apiClient.searchTVShow(query: query, page: page)
    }
    
    func searchPerson(query: String, page: Int?) -> Single<PersonResponseDTO> {
        return apiClient.searchPerson(query: query, page: page)
    }
}
