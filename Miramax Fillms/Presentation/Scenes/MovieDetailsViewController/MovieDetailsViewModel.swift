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
        let movieDetail: Driver<MovieDetail>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<MovieDetailRoute>
    private let movie: Movie

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<MovieDetailRoute>, movie: Movie) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.movie = movie
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        let viewTriggerO = trigger
            .take(1)
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        let movieDetailD = viewTriggerO
            .flatMapLatest {
                return self.repositoryProvider
                    .movieRepository()
                    .getMovieDetail(movieId: self.movie.id)
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .asDriverOnErrorJustComplete()
            }
            .asDriverOnErrorJustComplete()
        
        return Output(movieDetail: movieDetailD)
    }
}
