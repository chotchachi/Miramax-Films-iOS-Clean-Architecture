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
        let selfieTabTrigger: Driver<SelfieMovieTab>
        let selfieFrameSelectTrigger: Driver<SelfieFrame>
    }
    
    struct Output {
        let selfieFrameData: Driver<[SelfieFrame]>
        let recentlyFrameData: Driver<[SelfieFrame]>
//        let favoriteSelfieData: Driver<[FavoriteSelfie]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfieMovieRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfieMovieRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let allSelfieFrames = Observable.just(
            repositoryProvider
                .selfieRepository()
                .getAllFrame()
        )
        
        let recentlyFrameNames = Defaults.shared
            .getObservable(for: .recentSelfieFrames)
            .map { $0?.reversed() ?? [] }
        
        let recentlyFrames = Observable.combineLatest(recentlyFrameNames, allSelfieFrames) { recentlyFrameNames, selfieFrames in
            return recentlyFrameNames.compactMap { name -> SelfieFrame? in
                return selfieFrames.first(where: { $0.name == name })
            }
        }
        
        let favoriteFrameNames = Defaults.shared
            .getObservable(for: .favoriteSelfieFrames)
            .map { $0?.reversed() ?? [] }
        
        let favoriteFrames = Observable.combineLatest(favoriteFrameNames, allSelfieFrames) { favoriteFrameNames, selfieFrames in
            return favoriteFrameNames.compactMap { name -> SelfieFrame? in
                return selfieFrames.first(where: { $0.name == name })
            }
        }
        
        let selfieTabTrigger = input.selfieTabTrigger
            .asObservable()
            .startWith(SelfieMovieTab.defaultTab)
        
        let selfieFrameData = selfieTabTrigger
            .flatMapLatest { tab in
                switch tab {
                case .popular:
                    return allSelfieFrames
                case .favorite:
                    return favoriteFrames
                }
            }
            .asDriverOnErrorJustComplete()
        
//        let favoriteSelfies = repositoryProvider
//            .selfieRepository()
//            .getAllFavoriteSelfie()
//            .asDriver(onErrorJustReturn: [])
        
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
        
        return Output(selfieFrameData: selfieFrameData,
                      recentlyFrameData: recentlyFrames.asDriver(onErrorJustReturn: []))
    }
}
