//
//  EntertainmentDetailsViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator

class EntertainmentDetailsViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
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
        
        return Output(entertainmentDetail: entertainmentDetailD)
    }
    
    private func getEntertainmentDetails(_ model: EntertainmentModelType) -> Single<EntertainmentDetailModelType> {
        if model is Movie {
            return repositoryProvider
                .movieRepository()
                .getMovieDetail(movieId: model.entertainmentModelId)
                .map { $0 as EntertainmentDetailModelType }
        } else {
            return repositoryProvider
                .tvShowRepository()
                .getTVShowDetail(tvShowId: model.entertainmentModelId)
                .map { $0 as EntertainmentDetailModelType }
        }
    }
}