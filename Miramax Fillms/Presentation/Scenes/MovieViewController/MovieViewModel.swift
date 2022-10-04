//
//  MovieViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import Domain

enum MoviePreviewTab {
    case topRating
    case news
    case trending
}

class MovieViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let toSearchTrigger: Driver<Void>
        let retryGenreTrigger: Driver<Void>
        let retryUpcomingTrigger: Driver<Void>
        let retryPreviewTrigger: Driver<Void>
        let selectionEntertainmentTrigger: Driver<EntertainmentModelType>
        let selectionGenreTrigger: Driver<Genre>
        let previewTabTrigger: Driver<MoviePreviewTab>
        let seeMoreUpcomingTrigger: Driver<Void>
    }
    
    struct Output {
        let genresViewState: Driver<ViewState<Genre>>
        let upcomingViewState: Driver<ViewState<Movie>>
        let previewViewState: Driver<ViewState<Movie>>
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
        
        input.selectionEntertainmentTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentDetails(entertainment: item))
            })
            .disposed(by: rx.disposeBag)
        
        input.selectionGenreTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentList(type: .discover(genre: item)))
            })
            .disposed(by: rx.disposeBag)
        
        input.seeMoreUpcomingTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.entertainmentList(type: .movieUpcoming))
            })
            .disposed(by: rx.disposeBag)
        
        let retryGenreTriggerO = input.retryGenreTrigger
            .asObservable()
        
        let retryUpcomingTriggerO = input.retryUpcomingTrigger
            .asObservable()
        
        let genresViewStateD = Observable.merge(viewTriggerO, retryGenreTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .genreRepository()
                    .getGenreMovieList()
                    .map { ViewState.populated($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let upcomingViewStateD = Observable.merge(viewTriggerO, retryUpcomingTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .movieRepository()
                    .getUpComing(genreId: nil, page: nil)
                    .map { ViewState.populated($0.results) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let previewTabTriggerO = input.previewTabTrigger
            .asObservable()
            .startWith(.news)
        
        let retryPreviewWithSelectedTabO = input.retryPreviewTrigger
            .asObservable()
            .withLatestFrom(previewTabTriggerO)
        
        let previewViewStateD = Observable.merge(previewTabTriggerO, retryPreviewWithSelectedTabO)
            .flatMapLatest { tab in
                self.getPreviewData(with: tab)
                    .map { ViewState.populated($0.results) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        return Output(genresViewState: genresViewStateD,
                      upcomingViewState: upcomingViewStateD,
                      previewViewState: previewViewStateD)
    }
    
    private func getPreviewData(with tab: MoviePreviewTab) -> Observable<MovieResponse> {
        switch tab {
        case .topRating:
            return repositoryProvider
                .movieRepository()
                .getTopRated(genreId: nil, page: nil)
                .asObservable()
        case .news:
            return repositoryProvider
                .movieRepository()
                .getUpComing(genreId: nil, page: nil)
                .asObservable()
        case .trending:
            return repositoryProvider
                .movieRepository()
                .getPopular(genreId: nil, page: nil)
                .asObservable()
        }
    }
}
