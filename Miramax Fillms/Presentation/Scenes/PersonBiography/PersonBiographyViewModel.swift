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
        let person: Driver<Person>
    }
    
    private let router: UnownedRouter<PersonBiographyRoute>
    private let person: Person

    init(router: UnownedRouter<PersonBiographyRoute>, person: Person) {
        self.router = router
        self.person = person
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let personD = Driver.just(person)
        
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
        
        return Output(person: personD)
    }
}
