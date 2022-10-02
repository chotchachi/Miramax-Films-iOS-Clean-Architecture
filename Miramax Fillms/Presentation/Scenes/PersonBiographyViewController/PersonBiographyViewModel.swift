//
//  PersonBiographyViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

class PersonBiographyViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let shareTrigger: Driver<Void>
    }
    
    struct Output {
        let personDetail: Driver<PersonDetail>
    }
    
    private let router: UnownedRouter<PersonBiographyRoute>
    private let personDetail: PersonDetail

    init(router: UnownedRouter<PersonBiographyRoute>, personDetail: PersonDetail) {
        self.router = router
        self.personDetail = personDetail
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let personDetailD = Driver.just(personDetail)
        
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
        
        return Output(personDetail: personDetailD)
    }
}
