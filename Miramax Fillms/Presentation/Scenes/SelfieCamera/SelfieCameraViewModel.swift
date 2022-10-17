//
//  SelfieCameraViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/10/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import Domain

class SelfieCameraViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        let selfieFrame: Driver<SelfieFrame>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfieCameraRoute>
    private let selfieFrame: SelfieFrame

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfieCameraRoute>, selfieFrame: SelfieFrame) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.selfieFrame = selfieFrame
        super.init()
    }
    
    func transform(input: Input) -> Output {
        input.backTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        return Output(selfieFrame: Driver.just(selfieFrame))
    }
}
