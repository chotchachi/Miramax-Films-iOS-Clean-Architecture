//
//  SearchViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import RxCocoa
import RxSwift

class SearchViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let searchTrigger: Driver<String?>
    }
    
    struct Output {
        let searchViewDataItems: Driver<[SearchViewData]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    
    init(repositoryProvider: RepositoryProviderProtocol) {
        self.repositoryProvider = repositoryProvider
        super.init()
        
    }
    
    func transform(input: Input) -> Output {
        let searchTriggerD = input.searchTrigger
            .startWith(nil)
            .distinctUntilChanged()
        
        let searchViewDataItemsD = searchTriggerD
            .asObservable()
            .flatMapLatest { query -> Observable<[SearchViewData]> in
                if let query = query {
                    return self.search(query)
                } else {
                    return self.recent()
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(searchViewDataItems: searchViewDataItemsD)
    }
    
    private func search(_ query: String) -> Observable<[SearchViewData]> {
        let searchMovieO = Observable.just(query)
            .flatMapLatest {
                return self.repositoryProvider
                    .movieRepository()
                    .searchMovie(query: $0, page: nil)
                    .map { $0.results }
                    .catchAndReturn([])
            }
        
        let searchTVShowO = Observable.just(query)
            .flatMapLatest {
                return self.repositoryProvider
                    .movieRepository()
                    .searchMovie(query: $0, page: nil)
                    .map { $0.results }
                    .catchAndReturn([])
            }
        
        let searchPersonO = Observable.just(query)
            .flatMapLatest {
                return self.repositoryProvider
                    .personRepository()
                    .searchPerson(query: $0, page: nil)
                    .map { $0.results }
                    .catchAndReturn([])
            }

        return Observable.zip(searchMovieO, searchTVShowO, searchPersonO)
            .map { (movieItems, tvShowItems, personItems) in
                var searchViewDataItems: [SearchViewData] = []
                if !movieItems.isEmpty {
                    searchViewDataItems.append(.movie(items: movieItems))
                }
                if !tvShowItems.isEmpty {
                    searchViewDataItems.append(.tvShow(items: tvShowItems))
                }
                if !personItems.isEmpty {
                    searchViewDataItems.append(.actor(items: personItems))
                }
                return searchViewDataItems
            }
    }
    
    private func recent() -> Observable<[SearchViewData]> {
        return .just([.recent(items: [])])
    }
}
