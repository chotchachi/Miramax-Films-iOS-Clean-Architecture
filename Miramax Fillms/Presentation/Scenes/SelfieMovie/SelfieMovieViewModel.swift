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
        let recentlyFrameData: Driver<[SelfieFrame]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfieMovieRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfieMovieRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let selfieFrames = Driver.just(
            repositoryProvider
                .selfieRepository()
                .getAllFrame()
        )
        
        let recentlyFrameNames = Defaults.shared
            .getObservable(for: .recentSelfieFrames)
            .map { $0?.reversed() ?? [] }
            .asDriver(onErrorJustReturn: [])
        
        let recentlyFrames = Driver.combineLatest(recentlyFrameNames, selfieFrames) { recentlyFrameNames, selfieFrames in
            return recentlyFrameNames.compactMap { name -> SelfieFrame? in
                return selfieFrames.first(where: { $0.name == name })
            }
        }
        
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
        
        return Output(selfieFrameData: selfieFrames,
                      recentlyFrameData: recentlyFrames)
    }
}
