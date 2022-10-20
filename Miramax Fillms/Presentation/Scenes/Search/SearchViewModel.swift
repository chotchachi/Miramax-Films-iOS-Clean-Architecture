//
//  SearchViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import Domain

class SearchViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let searchTrigger: Driver<String?>
        let cancelTrigger: Driver<Void>
        let personSelectTrigger: Driver<PersonViewModel>
        let entertainmentSelectTrigger: Driver<EntertainmentViewModel>
        let clearAllSearchRecentTrigger: Driver<Void>
        let seeMoreMovieTrigger: Driver<Void>
        let seeMoreTVShowTrigger: Driver<Void>
        let seeMorePeopleTrigger: Driver<Void>
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
        /// Search query trigger
        let searchQueryTrigger = input.searchTrigger
            .startWith(nil)
            .distinctUntilChanged()
            .asObservable()
        
        /// Search recent entertainment data
        let recentEntertainment = repositoryProvider
            .searchRepository()
            .getRecentEntertainment()
        
        /// Combine search query & search recent
        /// If query not nil -> return search data with query
        /// If query was nil -> return search recent entertainment
        let searchViewDataItems = Observable.combineLatest(searchQueryTrigger, recentEntertainment)
            .flatMapLatest { (query, recentItems) -> Observable<[SearchViewData]> in
                if let query = query {
                    return self.search(query)
                } else {
                    return .just([.recent(items: recentItems.map { $0.asPresentation() })])
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        /// Save recent entertainment
        input.entertainmentSelectTrigger
            .asObservable()
            .flatMap {
                self.saveRecentEntertainment($0)
                    .catch { _ in Completable.empty() }
            }
            .subscribe()
            .disposed(by: rx.disposeBag)
        
        /// Clear all search recent entertainment
        input.clearAllSearchRecentTrigger
            .asObservable()
            .flatMap {
                self.clearAllRecentEntertainment()
                    .catch { _ in Completable.empty() }
            }
            .subscribe()
            .disposed(by: rx.disposeBag)
        
        input.cancelTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.dismiss)
            })
            .disposed(by: rx.disposeBag)
        
        input.personSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.personDetail(personId: item.id))
            })
            .disposed(by: rx.disposeBag)
        
        input.entertainmentSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentDetail(entertainmentId: item.id, entertainmentType: item.type))
            })
            .disposed(by: rx.disposeBag)
        
        input.seeMoreMovieTrigger
            .withLatestFrom(searchQueryTrigger.asDriverOnErrorJustComplete())
            .compactMap { $0 }
            .drive(onNext: { [weak self] query in
                guard let self = self else { return }
                self.router.trigger(.entertainmentList(query: query, entertainmentType: .movie))
            })
            .disposed(by: rx.disposeBag)
        
        input.seeMoreTVShowTrigger
            .withLatestFrom(searchQueryTrigger.asDriverOnErrorJustComplete())
            .compactMap { $0 }
            .drive(onNext: { [weak self] query in
                guard let self = self else { return }
                self.router.trigger(.entertainmentList(query: query, entertainmentType: .tvShow))
            })
            .disposed(by: rx.disposeBag)
        
        input.seeMorePeopleTrigger
            .withLatestFrom(searchQueryTrigger.asDriverOnErrorJustComplete())
            .compactMap { $0 }
            .drive(onNext: { [weak self] query in
                guard let self = self else { return }
                self.router.trigger(.personList(query: query))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(searchViewDataItems: searchViewDataItems)
    }
    
    private func search(_ query: String) -> Observable<[SearchViewData]> {
        let searchMovieO = Observable.just(query)
            .flatMapLatest {
                return self.repositoryProvider
                    .searchRepository()
                    .searchMovie(query: $0, page: nil)
                    .asObservable()
                    .catchAndReturn(BaseResponse.emptyResponse())
            }
        
        let searchTVShowO = Observable.just(query)
            .flatMapLatest {
                return self.repositoryProvider
                    .searchRepository()
                    .searchTVShow(query: $0, page: nil)
                    .asObservable()
                    .catchAndReturn(BaseResponse.emptyResponse())
            }
        
        let searchPersonO = Observable.just(query)
            .flatMapLatest {
                return self.repositoryProvider
                    .searchRepository()
                    .searchPerson(query: $0, page: nil)
                    .asObservable()
                    .catchAndReturn(BaseResponse.emptyResponse())
            }
        
        return Observable.zip(searchMovieO, searchTVShowO, searchPersonO, resultSelector: { movieResponse, tvShowResponse, personResponse in
            var searchViewDataItems: [SearchViewData] = []
            if !movieResponse.results.isEmpty {
                searchViewDataItems.append(.movie(items: movieResponse.results.map { $0.asPresentation() }, hasNextPage: movieResponse.hasNextPage))
            }
            if !tvShowResponse.results.isEmpty {
                searchViewDataItems.append(.tvShow(items: tvShowResponse.results.map { $0.asPresentation() }, hasNextPage: tvShowResponse.hasNextPage))
            }
            if !personResponse.results.isEmpty {
                searchViewDataItems.append(.actor(items: personResponse.results.map { $0.asPresentation() }, hasNextPage: personResponse.hasNextPage))
            }
            return searchViewDataItems
        }).trackActivity(loading)
    }
    
    private func saveRecentEntertainment(_ item: EntertainmentViewModel) -> Completable {
        let recentEntertainment = RecentEntertainment(
            id: item.id,
            name: item.name,
            backdropPath: item.backdropURL?.path,
            posterPath: item.posterURL?.path,
            type: item.type,
            createAt: Date()
        )
        return repositoryProvider
            .searchRepository()
            .addRecentEntertainment(item: recentEntertainment)
    }
    
    private func clearAllRecentEntertainment() -> Completable {
        return repositoryProvider
            .searchRepository()
            .removeAllRecentEntertainment()
    }
}
