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

fileprivate typealias QueryParams = (page: Int, isRefresh: Bool)

class EntertainmentListViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let popViewTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let refreshTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let entertainmentSelectTrigger: Driver<EntertainmentModelType>
    }
    
    struct Output {
        let responseRoute: Driver<EntertainmentsResponseRoute>
        let entertainmentData: Driver<[EntertainmentModelType]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<EntertainmentListRoute>
    private let responseRoute: EntertainmentsResponseRoute
    
    private var currentPage: Int = 1
    private var hasNextPage: Bool = false

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<EntertainmentListRoute>, responseRoute: EntertainmentsResponseRoute) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.responseRoute = responseRoute
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let responseRouteD = Driver.just(responseRoute)
        
        let refreshTriggerO = input.refreshTrigger
            .asObservable()
            .map { (1, true) }
                
        let loadMoreTriggerO = input.loadMoreTrigger
            .asObservable()
            .filter { self.hasNextPage }
            .map { (self.currentPage + 1, false) }
        
        let queryOptionsO = Observable.merge(refreshTriggerO, loadMoreTriggerO)
            .startWith((1, true))
        
        let retryTriggerO = input.retryTrigger
            .asObservable()
            .withLatestFrom(queryOptionsO)
        
        let entertainmentDataD = Observable.merge(queryOptionsO, retryTriggerO)
            .flatMapLatest { (page, isRefresh) -> Observable<(data: [EntertainmentModelType], isRefresh: Bool)> in
                self.getEntertainmentData(page: page)
                    .do(onSuccess: { [weak self] in
                        guard let self = self else { return }
                        self.currentPage = $0.entertainmentResponsePage
                        self.hasNextPage = $0.entertainmentResponsePage < $0.entertainmentResponseTotalPages
                    })
                    .map { $0.entertainmentResponseResult }
                    .map { ($0, isRefresh) }
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .catch { _ in Observable.empty() }
            }
            .scan([]) { acc, change -> [EntertainmentModelType] in
                if change.isRefresh {
                    return change.data
                } else {
                    return acc + change.data
                }
            }
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
                self.router.trigger(.entertainmentDetails(entertainment: item))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(
            responseRoute: responseRouteD,
            entertainmentData: entertainmentDataD
        )
    }
    
    private func getEntertainmentData(page: Int) -> Single<EntertainmentResponseModelType> {
        switch responseRoute {
        case .discover(genre: let genre):
            if genre.entertainmentType == .movie {
                return repositoryProvider
                    .movieRepository()
                    .getByGenre(genreId: genre.id, page: page)
                    .map { $0 as EntertainmentResponseModelType }
            } else {
                return repositoryProvider
                    .tvShowRepository()
                    .getByGenre(genreId: genre.id, page: page)
                    .map { $0 as EntertainmentResponseModelType }
            }
        case .recommendations(entertainment: let entertainment):
            if entertainment.entertainmentModelType == .movie {
                return repositoryProvider
                    .movieRepository()
                    .getRecommendations(movieId: entertainment.entertainmentModelId, page: page)
                    .map { $0 as EntertainmentResponseModelType }
            } else {
                return repositoryProvider
                    .tvShowRepository()
                    .getRecommendations(tvShowId: entertainment.entertainmentModelId, page: page)
                    .map { $0 as EntertainmentResponseModelType }
            }
        case .movieUpcoming:
            return repositoryProvider
                .movieRepository()
                .getUpComing(genreId: nil, page: page)
                .map { $0 as EntertainmentResponseModelType }
        case .showUpcoming:
            return repositoryProvider
                .tvShowRepository()
                .getOnTheAir(genreId: nil, page: page)
                .map { $0 as EntertainmentResponseModelType }
        }
    }
}
