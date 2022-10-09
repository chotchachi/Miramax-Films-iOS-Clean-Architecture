//
//  EntertainmentDetailsViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

class EntertainmentDetailsViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let toSeasonListTrigger: Driver<Void>
        let seasonSelectTrigger: Driver<Season>
        let castSelectTrigger: Driver<Cast>
        let entertainmentSelectTrigger: Driver<EntertainmentModelType>
        let shareTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let seeMoreRecommendTrigger: Driver<Void>
    }
    
    struct Output {
        let entertainment: Driver<EntertainmentModelType>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<EntertainmentDetailsRoute>
    private let entertainmentId: Int
    private let entertainmentType: EntertainmentType

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<EntertainmentDetailsRoute>, entertainmentId: Int, entertainmentType: EntertainmentType) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.entertainmentId = entertainmentId
        self.entertainmentType = entertainmentType
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTriggerO = trigger
            .take(1)
        
        let retryTriggerO = input.retryTrigger
            .asObservable()
        
        let entertainmentD = Observable.merge(viewTriggerO, retryTriggerO)
            .flatMapLatest {
                self.getEntertainmentDetails(self.entertainmentModel)
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .asDriverOnErrorJustComplete()
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
        
        input.toSeasonListTrigger
            .withLatestFrom(entertainmentD)
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                if let seasons = item.entertainmentModelSeasons {
                    self.router.trigger(.seasonsList(seasons: seasons))
                }
            })
            .disposed(by: rx.disposeBag)
        
        input.seasonSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.seasonDetail(seasonNumber: item.seasonNumber))
            })
            .disposed(by: rx.disposeBag)
        
        input.castSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.personDetail(personId: item.id))
            })
            .disposed(by: rx.disposeBag)
        
        input.entertainmentSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentDetail(entertainmentId: item.entertainmentModelId, entertainmentType: item.entertainmentModelType))
            })
            .disposed(by: rx.disposeBag)
        
        input.shareTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.share)
            })
            .disposed(by: rx.disposeBag)
        
        input.seeMoreRecommendTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.recommendations)
            })
            .disposed(by: rx.disposeBag)
        
        return Output(entertainment: entertainmentD)
    }
    
    private func getEntertainmentDetails() -> Single<EntertainmentModelType> {
        switch entertainmentType {
        case .movie:
            return repositoryProvider
                .movieRepository()
                .getDetail(movieId: entertainmentId)
                .map { $0 as EntertainmentModelType }
        case .tvShow:
            return repositoryProvider
                .tvShowRepository()
                .getDetail(tvShowId: entertainmentId)
                .map { $0 as EntertainmentModelType }
        }
    }
}
