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
        let popViewTrigger: Driver<Void>
        let selfieFrameSelectTrigger: Driver<SelfieFrame>
    }
    
    struct Output {
        let selfieFrameData: Driver<[SelfieFrame]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfieMovieRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfieMovieRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let selfieFrames = repositoryProvider
            .selfieRepository()
            .getAllFrame()
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        input.selfieFrameSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.chooseMovie(selfieFrame: item))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(selfieFrameData: Driver.just(selfieFrames))
    }
}
