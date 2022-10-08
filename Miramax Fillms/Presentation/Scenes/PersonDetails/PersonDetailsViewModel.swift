//
//  PersonDetailsViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

class PersonDetailsViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let shareTrigger: Driver<Void>
        let toBiographyTrigger: Driver<Void>
        let entertainmentSelectTrigger: Driver<EntertainmentModelType>
    }
    
    struct Output {
        let person: Driver<Person>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<PersonDetailsRoute>
    private let personId: Int

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<PersonDetailsRoute>, personId: Int) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.personId = personId
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTriggerO = trigger
            .take(1)
        
        let retryTriggerO = input.retryTrigger
            .asObservable()
        
        let personD = Observable.merge(viewTriggerO, retryTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .personRepository()
                    .getPersonDetail(personId: self.personId)
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
            .withLatestFrom(personD)
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.biography(person: item))
            })
            .disposed(by: rx.disposeBag)
        
        input.entertainmentSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentDetails(entertainment: item))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(person: personD)
    }
}
