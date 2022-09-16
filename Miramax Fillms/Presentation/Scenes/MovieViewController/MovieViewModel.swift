//
//  MovieViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import RxCocoa
import RxSwift

class MovieViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let retryGenreTrigger: Driver<Void>
        let retryUpComingTrigger: Driver<Void>
    }
    
    struct Output {
        let movieViewDataItems: Driver<[MovieViewData]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    
    init(repositoryProvider: RepositoryProviderProtocol) {
        self.repositoryProvider = repositoryProvider
        super.init()
        
        repositoryProvider.movieRepository()
            .getNowPlaying(genreId: nil, page: nil)
            .subscribe {
                print($0)
            }
            .disposed(by: rx.disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        let viewTriggerO = trigger
            .take(1)
        
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
            .map { [$0.0, $0.1] }
            .asDriver(onErrorJustReturn: [])
        
        return Output(movieViewDataItems: movieViewDataItems)
    }
}
