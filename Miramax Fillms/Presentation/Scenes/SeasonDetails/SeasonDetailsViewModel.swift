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
    private let seasonNumber: Int

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SeasonDetailsRoute>, tvShowId: Int, seasonNumber: Int) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.tvShowId = tvShowId
        self.seasonNumber = seasonNumber
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let episodesData = trigger
            .take(1)
            .flatMapLatest {
                return self.repositoryProvider
                    .tvShowRepository()
                    .getSeasonDetails(tvShowId: self.tvShowId, seasonNumber: self.seasonNumber)
                    .map { $0.episodes ?? [] }
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .retryWith(input.retryTrigger)
                    .catchAndReturn([])
            }
            .asDriverOnErrorJustComplete()
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        return Output(episodesData: episodesData)
    }
}
