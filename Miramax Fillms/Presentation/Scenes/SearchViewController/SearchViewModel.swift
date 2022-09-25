//
//  SearchViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import RxCocoa
import RxSwift
import XCoordinator

class SearchViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let searchTrigger: Driver<String?>
        let cancelTrigger: Driver<Void>
        let personSelectTrigger: Driver<Person>
        let entertainmentSelectTrigger: Driver<EntertainmentModelType>
    }
    
    struct Output {
        let searchViewDataItems: Driver<[SearchViewData]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SearchRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SearchRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
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
        
        input.cancelTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.dismiss)
            })
            .disposed(by: rx.disposeBag)
        
        input.personSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.personDetails(person: item))
            })
            .disposed(by: rx.disposeBag)
        
        input.entertainmentSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertaimentDetails(entertainment: item))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(searchViewDataItems: searchViewDataItemsD)
    }
    
    private func search(_ query: String) -> Observable<[SearchViewData]> {
        let searchMovieO = Observable.just(query)
            .flatMapLatest {
                return self.repositoryProvider
                    .searchRepository()
                    .searchMovie(query: $0, page: nil)
                    .map { $0.results }
                    .catchAndReturn([])
            }
        
        let searchTVShowO = Observable.just(query)
            .flatMapLatest {
                return self.repositoryProvider
                    .searchRepository()
                    .searchTVShow(query: $0, page: nil)
                    .map { $0.results }
                    .catchAndReturn([])
            }
        
        let searchPersonO = Observable.just(query)
            .flatMapLatest {
                return self.repositoryProvider
                    .searchRepository()
                    .searchPerson(query: $0, page: nil)
                    .map { $0.results }
                    .catchAndReturn([])
            }

        return Observable.zip(searchMovieO, searchTVShowO, searchPersonO)
            .trackActivity(loading)
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
