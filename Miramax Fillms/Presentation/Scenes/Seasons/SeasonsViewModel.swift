//
//  SeasonsViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

class SeasonsViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let seasonSelectTrigger: Driver<Season>
    }
    
    struct Output {
        let seasonsData: Driver<[Season]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SeasonsRoute>
    private let seasons: [Season]

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SeasonsRoute>, seasons: [Season]) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.seasons = seasons
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let seasonsDataD = Driver.just(seasons)
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        input.seasonSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.seasonDetail(seasonNumber: item.seasonNumber))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(seasonsData: seasonsDataD)
    }
}
