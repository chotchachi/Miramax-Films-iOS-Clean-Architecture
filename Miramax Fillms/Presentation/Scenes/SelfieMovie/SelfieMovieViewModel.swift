//
//  SelfieMovieViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/10/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import Domain

class SelfieMovieViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let dismissTrigger: Driver<Void>
    }
    
    struct Output {
        
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfieMovieRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfieMovieRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        input.dismissTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.dismiss)
            })
            .disposed(by: rx.disposeBag)
        
        return Output()
    }
}
