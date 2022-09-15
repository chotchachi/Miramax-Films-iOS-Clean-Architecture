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
    
    init(
        genreNetworking: GenreNetworking,
        movieNetworking: MovieNetworking
    ) {
        self.genreNetworking = genreNetworking
        self.movieNetworking = movieNetworking
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
    
    // MARK: - Show

}
