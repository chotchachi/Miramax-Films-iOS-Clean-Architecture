//
//  SelfiePreviewViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/10/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import UIKit
import Domain

class SelfiePreviewViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
    }
    
    struct Output {
        let finalImage: Driver<UIImage>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfiePreviewRoute>
    private let finalImage: UIImage
    
    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfiePreviewRoute>, finalImage: UIImage) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.finalImage = finalImage
        super.init()
    }
 
    func transform(input: Input) -> Output {
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        return Output(finalImage: Driver.just(finalImage))
    }
}
