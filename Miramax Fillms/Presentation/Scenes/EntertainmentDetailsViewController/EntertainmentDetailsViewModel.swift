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
        let personSelectTrigger: Driver<PersonModelType>
        let entertainmentSelectTrigger: Driver<EntertainmentModelType>
        let shareTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
    }
    
    struct Output {
        let entertainmentDetail: Driver<EntertainmentDetailModelType>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<EntertainmentDetailsRoute>
    private let entertainmentModel: EntertainmentModelType

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<EntertainmentDetailsRoute>, entertainmentModel: EntertainmentModelType) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.entertainmentModel = entertainmentModel
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTriggerO = trigger
            .take(1)
        
        let retryTriggerO = input.retryTrigger
            .asObservable()
        
        let entertainmentDetailD = Observable.merge(viewTriggerO, retryTriggerO)
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
            .withLatestFrom(entertainmentDetailD)
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                if let seasons = item.entertainmentSeasons {
                    self.router.trigger(.seasonsList(seasons: seasons))
                }
            })
            .disposed(by: rx.disposeBag)
        
        input.seasonSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.seasonDetails(season: item))
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
        
        input.shareTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.share)
            })
            .disposed(by: rx.disposeBag)
        
        return Output(entertainmentDetail: entertainmentDetailD)
    }
    
    private func getEntertainmentDetails(_ model: EntertainmentModelType) -> Single<EntertainmentDetailModelType> {
        switch model.entertainmentModelType {
        case .movie:
            return repositoryProvider
                .movieRepository()
                .getDetail(movieId: model.entertainmentModelId)
                .map { $0 as EntertainmentDetailModelType }
        case .tvShow:
            return repositoryProvider
                .tvShowRepository()
                .getDetail(tvShowId: model.entertainmentModelId)
                .map { $0 as EntertainmentDetailModelType }
        }
    }
}
