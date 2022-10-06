//
//  SettingViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 06/10/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

class SettingViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let toSearchTrigger: Driver<Void>
    }
    
    struct Output {
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SettingRoute>
    
    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SettingRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        input.toSearchTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.search)
            })
            .disposed(by: rx.disposeBag)
        
        return Output()
    }
}
