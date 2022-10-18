//
//  EntertainmentListViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

typealias EntertainmentListViewResult = (data: [EntertainmentViewModel], isRefresh: Bool)

fileprivate struct QueryOptions {
    let sortOption: SortOption
    let page: Int
    let isRefresh: Bool
}

class EntertainmentListViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let popViewTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let refreshTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let sortOptionTrigger: Driver<SortOption>
        let entertainmentSelectTrigger: Driver<EntertainmentViewModel>
    }
    
    struct Output {
        let responseRoute: Driver<EntertainmentsResponseRoute>
        let viewResult: Driver<EntertainmentListViewResult>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<EntertainmentListRoute>
    private let responseRoute: EntertainmentsResponseRoute
    
    private var currentPage: Int = 1
    private var hasNextPage: Bool = false
    
    public var currentSortOption: SortOption
    public let sortOptions: [SortOption]

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<EntertainmentListRoute>, responseRoute: EntertainmentsResponseRoute) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.responseRoute = responseRoute
        let sortOptions = repositoryProvider
            .optionsRepository()
            .getSortOptions()
        self.sortOptions = sortOptions
        self.currentSortOption = sortOptions.first!
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let sortOptionTrigger = input.sortOptionTrigger
            .asObservable()
            .distinctUntilChanged()
            .do(onNext: { sortOption in
                self.currentSortOption = sortOption
            })
            .map { QueryOptions(sortOption: $0, page: 1, isRefresh: true) }
        
        let refreshTrigger = input.refreshTrigger
            .asObservable()
            .map { QueryOptions(sortOption: self.currentSortOption, page: 1, isRefresh: true) }
                
        let loadMoreTrigger = input.loadMoreTrigger
            .asObservable()
            .filter { self.hasNextPage }
            .map { QueryOptions(sortOption: self.currentSortOption, page: self.currentPage + 1, isRefresh: false) }

        let queryOptions = Observable.merge(sortOptionTrigger, refreshTrigger, loadMoreTrigger)
            .startWith(QueryOptions(sortOption: self.currentSortOption, page: 1, isRefresh: true))
        
        let viewResult = queryOptions
            .flatMapLatest { options -> Observable<(data: [EntertainmentViewModel], isRefresh: Bool)> in
                self.getEntertainmentData(page: options.page, sortOption: options.sortOption)
                    .do(onSuccess: { [weak self] in
                        guard let self = self else { return }
                        self.currentPage = $0.page
                        self.hasNextPage = $0.page < $0.totalPages
                    })
                    .map { ($0.results, options.isRefresh) }
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .retryWith(input.retryTrigger)
                    .catch { _ in Observable.empty() }
            }
            .scan(([], true)) { acc, change -> EntertainmentListViewResult in
                if change.isRefresh {
                    return (change.data, change.isRefresh)
                } else {
                    return (acc.0 + change.data, change.isRefresh)
                }
            }
            .map { $0 as EntertainmentListViewResult }
            .asDriverOnErrorJustComplete()
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        input.toSearchTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.search)
            })
            .disposed(by: rx.disposeBag)
        
        input.entertainmentSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentDetail(entertainmentId: item.id, entertainmentType: item.type))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(
            responseRoute: Driver.just(responseRoute),
            viewResult: viewResult
        )
    }
    
    private func getEntertainmentData(page: Int, sortOption: SortOption) -> Single<EntertainmentResponseViewModel> {
        switch responseRoute {
        case .discover(genre: let genre):
            if genre.entertainmentType == .movie {
                return repositoryProvider
                    .movieRepository()
                    .getByGenre(genreId: genre.id, sortOption: sortOption, page: page)
                    .map { response in
                        EntertainmentResponseViewModel(
                            page: response.page,
                            results: response.results.map { $0.asPresentation() },
                            totalPages: response.totalPages,
                            totalResults: response.totalResults
                        )
                    }
            } else {
                return repositoryProvider
                    .tvShowRepository()
                    .getByGenre(genreId: genre.id, sortOption: sortOption, page: page)
                    .map { response in
                        EntertainmentResponseViewModel(
                            page: response.page,
                            results: response.results.map { $0.asPresentation() },
                            totalPages: response.totalPages,
                            totalResults: response.totalResults
                        )
                    }
            }
        case .recommendations(entertainmentId: let entertainmentId, entertainmentType: let entertainmentType):
            if entertainmentType == .movie {
                return repositoryProvider
                    .movieRepository()
                    .getRecommendations(movieId: entertainmentId, page: page)
                    .map { response in
                        EntertainmentResponseViewModel(
                            page: response.page,
                            results: response.results.map { $0.asPresentation() },
                            totalPages: response.totalPages,
                            totalResults: response.totalResults
                        )
                    }
            } else {
                return repositoryProvider
                    .tvShowRepository()
                    .getRecommendations(tvShowId: entertainmentId, page: page)
                    .map { response in
                        EntertainmentResponseViewModel(
                            page: response.page,
                            results: response.results.map { $0.asPresentation() },
                            totalPages: response.totalPages,
                            totalResults: response.totalResults
                        )
                    }
            }
        case .movieUpcoming:
            return repositoryProvider
                .movieRepository()
                .getUpComing(genreId: nil, page: page)
                .map { response in
                    EntertainmentResponseViewModel(
                        page: response.page,
                        results: response.results.map { $0.asPresentation() },
                        totalPages: response.totalPages,
                        totalResults: response.totalResults
                    )
                }
        case .movieTopRating:
            return repositoryProvider
                .movieRepository()
                .getTopRated(genreId: nil, page: page)
                .map { response in
                    EntertainmentResponseViewModel(
                        page: response.page,
                        results: response.results.map { $0.asPresentation() },
                        totalPages: response.totalPages,
                        totalResults: response.totalResults
                    )
                }
        case .movieNews:
            return repositoryProvider
                .movieRepository()
                .getNowPlaying(genreId: nil, page: page)
                .map { response in
                    EntertainmentResponseViewModel(
                        page: response.page,
                        results: response.results.map { $0.asPresentation() },
                        totalPages: response.totalPages,
                        totalResults: response.totalResults
                    )
                }
        case .movieTrending:
            return repositoryProvider
                .movieRepository()
                .getPopular(genreId: nil, page: page)
                .map { response in
                    EntertainmentResponseViewModel(
                        page: response.page,
                        results: response.results.map { $0.asPresentation() },
                        totalPages: response.totalPages,
                        totalResults: response.totalResults
                    )
                }
        case .showUpcoming:
            return repositoryProvider
                .tvShowRepository()
                .getOnTheAir(genreId: nil, page: page)
                .map { response in
                    EntertainmentResponseViewModel(
                        page: response.page,
                        results: response.results.map { $0.asPresentation() },
                        totalPages: response.totalPages,
                        totalResults: response.totalResults
                    )
                }
        case .showTopRating:
            return repositoryProvider
                .tvShowRepository()
                .getTopRated(genreId: nil, page: page)
                .map { response in
                    EntertainmentResponseViewModel(
                        page: response.page,
                        results: response.results.map { $0.asPresentation() },
                        totalPages: response.totalPages,
                        totalResults: response.totalResults
                    )
                }
        case .showNews:
            return repositoryProvider
                .tvShowRepository()
                .getOnTheAir(genreId: nil, page: page)
                .map { response in
                    EntertainmentResponseViewModel(
                        page: response.page,
                        results: response.results.map { $0.asPresentation() },
                        totalPages: response.totalPages,
                        totalResults: response.totalResults
                    )
                }
        case .showTrending:
            return repositoryProvider
                .tvShowRepository()
                .getPopular(genreId: nil, page: page)
                .map { response in
                    EntertainmentResponseViewModel(
                        page: response.page,
                        results: response.results.map { $0.asPresentation() },
                        totalPages: response.totalPages,
                        totalResults: response.totalResults
                    )
                }
        case .search(query: let query, entertainmentType: let entertainmentType):
            if entertainmentType == .movie {
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
            } else {
                return repositoryProvider
                    .searchRepository()
                    .searchTVShow(query: query, page: page)
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
    }
}
