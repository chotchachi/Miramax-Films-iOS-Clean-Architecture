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
        let type: Driver<EntertainmentListType>
        let entertainmentData: Driver<[EntertainmentModelType]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<EntertainmentListRoute>
    private let type: EntertainmentListType
    
    private var currentPage: Int = 1
    private var hasNextPage: Bool = false

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<EntertainmentListRoute>, type: EntertainmentListType) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.type = type
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let typeD = Driver.just(type)
        
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
            .flatMapLatest {
                self.getEntertainmentData(with: $0)
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
            type: typeD,
            entertainmentData: entertainmentDataD
        )
    }
    
    private func getEntertainmentData(with params: QueryParams) -> Single<(data: [EntertainmentModelType], isRefresh: Bool)> {
        let (page, isRefresh) = params
        switch type {
        case .discover(let genre):
            if genre.entertainmentType == .movie {
                return repositoryProvider
                    .movieRepository()
                    .getByGenre(genreId: genre.id, page: page)
                    .do(onSuccess: { [weak self] in
                        guard let self = self else { return }
                        self.currentPage = $0.page
                        self.hasNextPage = $0.page < $0.totalPages
                    })
                        .map { $0.results as [EntertainmentModelType] }
                        .map { ($0, isRefresh) }
            } else {
                return repositoryProvider
                    .tvShowRepository()
                    .getByGenre(genreId: genre.id, page: page)
                    .do(onSuccess: { [weak self] in
                        guard let self = self else { return }
                        self.currentPage = $0.page
                        self.hasNextPage = $0.page < $0.totalPages
                    })
                    .map { $0.results as [EntertainmentModelType] }
                    .map { ($0, isRefresh) }
            }
        case .movieUpcoming:
            return repositoryProvider
                .movieRepository()
                .getUpComing(genreId: nil, page: page)
                .do(onSuccess: { [weak self] in
                    guard let self = self else { return }
                    self.currentPage = $0.page
                    self.hasNextPage = $0.page < $0.totalPages
                })
                    .map { $0.results as [EntertainmentModelType] }
                    .map { ($0, isRefresh) }
        case .showUpcoming:
            return repositoryProvider
                .tvShowRepository()
                .getAiringToday(genreId: nil, page: page)
                .do(onSuccess: { [weak self] in
                    guard let self = self else { return }
                    self.currentPage = $0.page
                    self.hasNextPage = $0.page < $0.totalPages
                })
                    .map { $0.results as [EntertainmentModelType] }
                    .map { ($0, isRefresh) }
        }
    }
}
