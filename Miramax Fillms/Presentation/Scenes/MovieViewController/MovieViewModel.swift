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
        
        let genreViewStateO = Observable.merge(viewTriggerO, retryGenreTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .genreRepository()
                    .getGenreMovieList()
                    .map { ViewState.populated($0.genres) }
                    .catchAndReturn(.error(NSError(domain: "", code: 1)))
            }
            .startWith(.initial)
        
        let genreViewStateD = genreViewStateO
            .asDriver(onErrorJustReturn: .empty)
        
        let movieViewDataItems = genreViewStateD
            .map { [MovieViewData.genreViewState(viewState: $0)] }
        
        return Output(movieViewDataItems: movieViewDataItems)
    }
}
