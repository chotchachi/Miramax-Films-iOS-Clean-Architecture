//
//  TVShowViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxCocoa
import RxSwift
import XCoordinator

class TVShowViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let toSearchTrigger: Driver<Void>
        let retryGenreTrigger: Driver<Void>
        let retryAiringTodayTrigger: Driver<Void>
        let retryUpComingTrigger: Driver<Void>
    }
    
    struct Output {
        let tvShowViewDataItems: Driver<[TVShowViewData]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<TVShowRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<TVShowRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        let viewTriggerO = trigger
            .take(1)
        
        input.toSearchTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.search)
            })
            .disposed(by: rx.disposeBag)
        
        let retryGenreTriggerO = input.retryGenreTrigger
            .asObservable()
        
        let retryAiringTodayTriggerO = input.retryAiringTodayTrigger
            .asObservable()
        
        let retryUpComingTriggerO = input.retryUpComingTrigger
            .asObservable()
        
        let genreViewStateO = Observable.merge(viewTriggerO, retryGenreTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .genreRepository()
                    .getGenreShowList()
                    .map { ViewState.populated($0.genres) }
                    .catchAndReturn(.error(NSError(domain: "", code: 1)))
            }
            .startWith(.initial)
            .map { TVShowViewData.genreViewState(viewState: $0) }
        
        let airingTodayViewStateO = Observable.merge(viewTriggerO, retryAiringTodayTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .tvShowRepository()
                    .getAiringToday(genreId: nil, page: nil)
                    .map { ViewState.populated($0.results) }
                    .catchAndReturn(.error(NSError(domain: "", code: 1)))
            }
            .startWith(.initial)
            .map { TVShowViewData.airingTodayViewState(viewStatte: $0) }
        
        let onTheAirViewStateO = Observable.merge(viewTriggerO, retryUpComingTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .tvShowRepository()
                    .getOnTheAir(genreId: nil, page: nil)
                    .map { ViewState.populated($0.results) }
                    .catchAndReturn(.error(NSError(domain: "", code: 1)))
            }
            .startWith(.initial)
            .map { TVShowViewData.onTheAirViewState(viewState: $0) }

        let tvShowViewDataItems = Observable.combineLatest(
            genreViewStateO,
            airingTodayViewStateO,
            onTheAirViewStateO
        )
            .map { [$0.0, $0.1, $0.2, .tabSelection] }
            .asDriver(onErrorJustReturn: [])
        
        return Output(tvShowViewDataItems: tvShowViewDataItems)
    }
}
