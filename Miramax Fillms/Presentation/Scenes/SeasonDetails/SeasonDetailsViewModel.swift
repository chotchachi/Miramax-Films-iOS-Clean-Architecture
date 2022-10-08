//
//  SeasonDetailsViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

class SeasonDetailsViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let episodeSelectTrigger: Driver<Episode>
    }
    
    struct Output {
        let episodesData: Driver<[Episode]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SeasonDetailsRoute>
    private let tvShowId: Int
    private let season: Season

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SeasonDetailsRoute>, tvShowId: Int, season: Season) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.tvShowId = tvShowId
        self.season = season
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTriggerO = trigger
            .take(1)
        
        let retryTriggerO = input.retryTrigger
            .asObservable()
        
        let episodesDataD = Observable.merge(viewTriggerO, retryTriggerO)
            .flatMapLatest {
                return self.repositoryProvider
                    .tvShowRepository()
                    .getSeasonDetails(tvShowId: self.tvShowId, seasonNumber: self.season.seasonNumber)
                    .map { $0.episodes ?? [] }
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .catchAndReturn([])
            }
            .asDriverOnErrorJustComplete()
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        return Output(episodesData: episodesDataD)
    }
}
