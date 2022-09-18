//
//  RepositoryProviderProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

protocol RepositoryProviderProtocol {
    func genreRepository() -> GenreRepositoryProtocol
    func movieRepository() -> MovieRepositoryProtocol
    func tvShowRepository() -> TVShowRepositoryProtocol
    func personRepository() -> PersonRepositoryProtocol
}
