//
//  MovieDetailsViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator

class MovieDetailsViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let shareTrigger: Driver<Void>
    }
    
    struct Output {
        
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<MovieDetailRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<MovieDetailRoute>, movie: Movie) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        return Output()
    }
}
