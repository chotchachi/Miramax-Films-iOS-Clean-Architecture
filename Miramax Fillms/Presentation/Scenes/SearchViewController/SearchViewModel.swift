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
        let personSelectTrigger: Driver<PersonModelType>
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
        let searchTriggerO = input.searchTrigger
            .startWith(nil)
            .distinctUntilChanged()
            .asObservable()
        
        let recentEntertainmentO = repositoryProvider
            .searchRepository()
            .getRecentEntertainment()
        
        let searchViewDataItemsD = Observable.combineLatest(searchTriggerO, recentEntertainmentO)
            .flatMapLatest { (query, recentItems) -> Observable<[SearchViewData]> in
                if let query = query {
                    return self.search(query)
                } else {
                    return .just([.recent(items: recentItems)])
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
                self.router.trigger(.entertainmentDetails(entertainment: item))
            })
            .disposed(by: rx.disposeBag)
        
        // Save recent entertainment
        input.entertainmentSelectTrigger
            .asObservable()
            .flatMapLatest { self.saveRecentEntertainment($0) }
            .subscribe()
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
    
    private func saveRecentEntertainment(_ item: EntertainmentModelType) -> Observable<Void> {
        let recentEntertainment = RecentEntertainment(
            id: item.entertainmentModelId,
            name: item.entertainmentModelName,
            posterPath: item.entertainmentModelPosterURL?.path,
            type: item.entertainmentModelType
        )
        return repositoryProvider
            .searchRepository()
            .addRecentEntertainment(item: recentEntertainment)
            .catch { _ in Observable.empty() }
    }
}
