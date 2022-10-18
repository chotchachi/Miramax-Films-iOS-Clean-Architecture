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
    }
    
    struct Output {
        let selfieFrame: Driver<SelfieFrame>
        let movieImage: Driver<UIImage>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfieCameraRoute>
    private let selfieFrame: SelfieFrame
    private let movieImage: UIImage
    
    private let movieImageS = PublishRelay<UIImage>()

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfieCameraRoute>, selfieFrame: SelfieFrame, movieImage: UIImage) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.selfieFrame = selfieFrame
        self.movieImage = movieImage
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let movieImageData = Driver.merge(Driver.just(movieImage), movieImageS.asDriverOnErrorJustComplete())
        
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
        
        return Output(selfieFrame: Driver.just(selfieFrame),
                      movieImage: movieImageData)
    }
}
