//
//  SelfieCameraViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/10/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import UIKit
import Domain

class SelfieCameraViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let selectMovieImageTrigger: Driver<Void>
        let selectSelfieFrameTrigger: Driver<SelfieFrame?>
        let doneTrigger: Driver<(UIImage, SelfieFrame?)>
    }
    
    struct Output {
        let selfieFrame: Driver<SelfieFrame?>
        let movie: Driver<EntertainmentViewModel>
        let selfieFrameData: Driver<[SelfieFrame]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfieCameraRoute>
    
    private let selfieFrameS: BehaviorRelay<SelfieFrame?>
    private let movieS: BehaviorRelay<EntertainmentViewModel>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfieCameraRoute>, selfieFrame: SelfieFrame, movie: EntertainmentViewModel) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.selfieFrameS = BehaviorRelay(value: selfieFrame)
        self.movieS = BehaviorRelay(value: movie)
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTrigger = trigger
            .take(1)
        
        let selfieFrame = viewTrigger
            .flatMapLatest { self.selfieFrameS }
            .asDriverOnErrorJustComplete()
        
        let movieData = viewTrigger
            .flatMapLatest { self.movieS }
            .asDriverOnErrorJustComplete()
        
        let selfieFrames = Driver.just(
            repositoryProvider
                .selfieRepository()
                .getAllFrame()
        )
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        input.selectMovieImageTrigger
            .drive(onNext: { [weak self] in
                self?.router.trigger(.selectMovieImage(callback: { movie in
                    self?.movieS.accept(movie)
                }))
            })
            .disposed(by: rx.disposeBag)
        
        input.doneTrigger
            .drive(onNext: { [weak self] tuple in
                guard let self = self else { return }
                self.router.trigger(.preview(image: tuple.0, selfieFrame: tuple.1))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(selfieFrame: selfieFrame,
                      movie: movieData,
                      selfieFrameData: selfieFrames)
    }
}
