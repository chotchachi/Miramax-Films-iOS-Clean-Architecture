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
        let doneTrigger: Driver<(UIImage, SelfieFrame)>
    }
    
    struct Output {
        let selfieFrame: Driver<SelfieFrame>
        let movieImage: Driver<UIImage>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfieCameraRoute>
    private let selfieFrame: SelfieFrame
    
    private let movieImageS: BehaviorRelay<UIImage>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfieCameraRoute>, selfieFrame: SelfieFrame, movieImage: UIImage) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.selfieFrame = selfieFrame
        self.movieImageS = BehaviorRelay(value: movieImage)
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTrigger = trigger
            .take(1)
        
        let selfieFrame = viewTrigger
            .map { self.selfieFrame }
            .asDriverOnErrorJustComplete()
        
        let movieImageData = viewTrigger
            .flatMapLatest { self.movieImageS }
            .asDriverOnErrorJustComplete()
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        input.selectMovieImageTrigger
            .drive(onNext: { [weak self] in
                self?.router.trigger(.selectMovieImage(callback: { movieImage in
                    self?.movieImageS.accept(movieImage)
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
                      movieImage: movieImageData)
    }
}
