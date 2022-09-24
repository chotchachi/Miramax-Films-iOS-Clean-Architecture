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
    }
    
    struct Output {
        
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
        
        return Output()
    }
}
