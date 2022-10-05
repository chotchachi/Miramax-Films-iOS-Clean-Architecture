//
//  GenresViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

class GenresViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let toSearchTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let genreSelectTrigger: Driver<Genre>
    }
    
    struct Output {
        let genres: Driver<[Genre]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<GenresRoute>
    
    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<GenresRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTriggerO = trigger
            .take(1)
        
        let retryTriggerO = input.retryTrigger
            .asObservable()
        
        let genresD = Observable.merge(viewTriggerO, retryTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .genreRepository()
                    .getGenreMovieList()
                    .trackActivity(self.loading)
                    .trackError(self.error)
                    .catchAndReturn([])
            }
            .asDriverOnErrorJustComplete()
        
        input.toSearchTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.search)
            })
            .disposed(by: rx.disposeBag)
        
        input.genreSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.discover(genre: item))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(genres: genresD)
    }
}
