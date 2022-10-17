//
//  ChooseMovieViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/10/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import Domain

typealias MovieSearchViewResult = (data: [EntertainmentViewModel], isRefresh: Bool)

fileprivate struct QueryOptions {
    let query: String?
    let page: Int
    let isRefresh: Bool
}

class ChooseMovieViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let searchTrigger: Driver<String?>
        let retryTrigger: Driver<Void>
        let refreshTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
    }
    
    struct Output {
        let searchResult: Driver<MovieSearchViewResult>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<ChooseMovieRoute>

    private var currentPage: Int = 1
    private var hasNextPage: Bool = false
    private var currentSearchQuery: String? = nil
    
    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<ChooseMovieRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let searchQueryTrigger = input.searchTrigger
            .asObservable()
            .distinctUntilChanged()
            .do(onNext: { query in
                self.currentSearchQuery = query
            })
            .map { QueryOptions(query: $0, page: 1, isRefresh: true) }
        
        let refreshTrigger = input.refreshTrigger
            .asObservable()
            .map { QueryOptions(query: self.currentSearchQuery, page: 1, isRefresh: true) }
        
        let loadMoreTrigger = input.loadMoreTrigger
            .asObservable()
            .filter { self.hasNextPage }
            .map { QueryOptions(query: self.currentSearchQuery, page: self.currentPage + 1, isRefresh: false) }
        
        let queryOptions = Observable.merge(refreshTrigger, loadMoreTrigger, searchQueryTrigger)
        
        let retryTrigger = input.retryTrigger
            .asObservable()
            .withLatestFrom(queryOptions)
        
        let searchResult = Observable.merge(queryOptions, retryTrigger)
            .filter { $0.query != nil }
            .flatMapLatest { options -> Observable<(data: [EntertainmentViewModel], isRefresh: Bool)> in
                self.searchMovies(query: options.query!, page: options.page)
                    .do(onSuccess: { [weak self] in
                        guard let self = self else { return }
                        self.currentPage = $0.page
                        self.hasNextPage = $0.page < $0.totalPages
                    })
                    .map { $0.results }
                    .map { ($0, options.isRefresh) }
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .catch { _ in Observable.empty() }
            }
            .scan(([], true)) { acc, change -> MovieSearchViewResult in
                if change.isRefresh {
                    return (change.data, change.isRefresh)
                } else {
                    return (acc.0 + change.data, change.isRefresh)
                }
            }
            .map { $0 as MovieSearchViewResult }
            .asDriverOnErrorJustComplete()
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        return Output(searchResult: searchResult)
    }
    
    private func searchMovies(query: String, page: Int) -> Single<EntertainmentResponseViewModel> {
        return repositoryProvider
            .searchRepository()
            .searchMovie(query: query, page: page)
            .map { response in
                EntertainmentResponseViewModel(
                    page: response.page,
                    results: response.results.map { $0.asPresentation() },
                    totalPages: response.totalPages,
                    totalResults: response.totalResults
                )
            }
    }
}
