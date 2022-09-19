//
//  MovieViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import RxCocoa
import RxSwift
import XCoordinator

class MovieViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let toSearchTrigger: Driver<Void>
        let retryGenreTrigger: Driver<Void>
        let retryUpComingTrigger: Driver<Void>
        let movieSelectTrigger: Driver<Movie>
    }
    
    struct Output {
        let movieViewDataItems: Driver<[MovieViewData]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<MovieRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<MovieRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        let viewTriggerO = trigger
            .take(1)
        
        input.toSearchTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.search)
            })
            .disposed(by: rx.disposeBag)
        
        input.movieSelectTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.detail(movie: $0))
            })
            .disposed(by: rx.disposeBag)
        
        let retryGenreTriggerO = input.retryGenreTrigger
            .asObservable()
        
        let retryUpComingTriggerO = input.retryUpComingTrigger
            .asObservable()
        
        let genreViewStateO = Observable.merge(viewTriggerO, retryGenreTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .genreRepository()
                    .getGenreMovieList()
                    .map { ViewState.populated($0.genres) }
                    .catchAndReturn(.error(NSError(domain: "", code: 1)))
            }
            .startWith(.initial)
            .map { MovieViewData.genreViewState(viewState: $0) }
        
        let upComingViewStateO = Observable.merge(viewTriggerO, retryUpComingTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .movieRepository()
                    .getUpComing(genreId: nil, page: nil)
                    .map { ViewState.populated($0.results) }
                    .catchAndReturn(.error(NSError(domain: "", code: 1)))
            }
            .startWith(.initial)
            .map { MovieViewData.upComingViewState(viewState: $0) }

        let movieViewDataItems = Observable.combineLatest(
            genreViewStateO,
            upComingViewStateO
        )
            .map { [$0.0, $0.1, .selfieWithMovie, .tabSelection] }
            .asDriver(onErrorJustReturn: [])
        
        return Output(movieViewDataItems: movieViewDataItems)
    }
}
