//
//  PersonDetailsViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator

class PersonDetailsViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let shareTrigger: Driver<Void>
        let toBiographyTrigger: Driver<Void>
    }
    
    struct Output {
        let personDetail: Driver<PersonDetail>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<PersonDetailsRoute>
    private let personModel: PersonModelType

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<PersonDetailsRoute>, personModel: PersonModelType) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.personModel = personModel
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTriggerO = trigger
            .take(1)
        
        let retryTriggerO = input.retryTrigger
            .asObservable()
        
        let personDetailD = Observable.merge(viewTriggerO, retryTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .personRepository()
                    .getPersonDetail(personId: self.personModel.personModelId)
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
        
        input.shareTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.share)
            })
            .disposed(by: rx.disposeBag)
        
        input.toBiographyTrigger
            .withLatestFrom(personDetailD)
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.biography(personDetail: item))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(personDetail: personDetailD)
    }
}
