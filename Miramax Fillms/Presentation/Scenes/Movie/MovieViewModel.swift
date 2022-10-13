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

class MovieViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let toSearchTrigger: Driver<Void>
        let retryGenreTrigger: Driver<Void>
        let retryNowPlayingTrigger: Driver<Void>
        let retryUpcomingTrigger: Driver<Void>
        let retryPreviewTrigger: Driver<Void>
        let selectionEntertainmentTrigger: Driver<EntertainmentViewModel>
        let selectionGenreTrigger: Driver<Genre>
        let previewTabTrigger: Driver<MoviePreviewTab>
        let seeMoreUpcomingTrigger: Driver<Void>
        let seeMorePreviewTrigger: Driver<Void>
        let toggleBookmarkTrigger: Driver<EntertainmentViewModel>
    }
    
    struct Output {
        let genresViewState: Driver<ViewState<Genre>>
        let nowPlayingViewState: Driver<ViewState<EntertainmentViewModel>>
        let upcomingViewState: Driver<ViewState<EntertainmentViewModel>>
        let previewViewState: Driver<ViewState<EntertainmentViewModel>>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<MovieRoute>
    
    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<MovieRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTrigger = trigger
            .take(1)
        
        let retryGenreTrigger = input.retryGenreTrigger
            .asObservable()
        
        let retryNowPlayingTrigger = input.retryNowPlayingTrigger
            .asObservable()
        
        let retryUpcomingTrigger = input.retryUpcomingTrigger
            .asObservable()
        
        let genresViewState = Observable.merge(viewTrigger, retryGenreTrigger)
            .flatMapLatest {
                self.repositoryProvider
                    .genreRepository()
                    .getGenreMovieList()
                    .map { ViewState.success($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let nowPlayingViewState = Observable.merge(viewTrigger, retryNowPlayingTrigger)
            .flatMapLatest {
                self.repositoryProvider
                    .movieRepository()
                    .getNowPlaying(genreId: nil, page: nil)
                    .map { response in response.results.map { $0.asPresentation() } }
                    .map { ViewState.success($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let upcomingViewState = Observable.merge(viewTrigger, retryUpcomingTrigger)
            .flatMapLatest {
                self.repositoryProvider
                    .movieRepository()
                    .getUpComing(genreId: nil, page: nil)
                    .map { response in response.results.map { $0.asPresentation() } }
                    .map { ViewState.success($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let bookmarkMovieData = repositoryProvider
            .entertainmentRepository()
            .getAllBookmarkEntertainmentMovie()
            .catchAndReturn([])
        
        let previewTabTrigger = input.previewTabTrigger
            .asObservable()
            .startWith(MoviePreviewTab.defaultTab)
        
        let retryPreviewWithSelectedTab = input.retryPreviewTrigger
            .asObservable()
            .withLatestFrom(previewTabTrigger)
        
        let previewViewState = Observable.merge(previewTabTrigger, retryPreviewWithSelectedTab)
            .flatMapLatest { tab in
                return Observable.combineLatest(
                    self.getPreviewData(with: tab).asObservable(),
                    bookmarkMovieData
                ) { self.combinePreviewDataWithBookmark(data: $0, bookmarkData: $1) }
                    .map { items in items.map { $0.asPresentation() } }
                    .map { ViewState.success($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        input.toggleBookmarkTrigger
            .asObservable()
            .flatMapLatest { self.toggleBookmarkItem(with: $0) }
            .subscribe()
            .disposed(by: rx.disposeBag)
        
        input.toSearchTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.search)
            })
            .disposed(by: rx.disposeBag)
        
        input.selectionEntertainmentTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentDetail(entertainmentId: item.id, entertainmentType: item.type))
            })
            .disposed(by: rx.disposeBag)
        
        input.selectionGenreTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentList(responseRoute: .discover(genre: item)))
            })
            .disposed(by: rx.disposeBag)
        
        input.seeMoreUpcomingTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.entertainmentList(responseRoute: .movieUpcoming))
            })
            .disposed(by: rx.disposeBag)
        
        input.seeMorePreviewTrigger
            .asObservable()
            .withLatestFrom(previewTabTrigger)
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] tab in
                guard let self = self else { return }
                switch tab {
                case .topRating:
                    self.router.trigger(.entertainmentList(responseRoute: .movieTopRating))
                case .news:
                    self.router.trigger(.entertainmentList(responseRoute: .movieNews))
                case .trending:
                    self.router.trigger(.entertainmentList(responseRoute: .movieTrending))
                }
            })
            .disposed(by: rx.disposeBag)
        
        return Output(genresViewState: genresViewState,
                      nowPlayingViewState: nowPlayingViewState,
                      upcomingViewState: upcomingViewState,
                      previewViewState: previewViewState)
    }
    
    private func getPreviewData(with tab: MoviePreviewTab) -> Single<[Movie]> {
        switch tab {
        case .topRating:
            return repositoryProvider
                .movieRepository()
                .getTopRated(genreId: nil, page: nil)
                .map { $0.results }
        case .news:
            return repositoryProvider
                .movieRepository()
                .getNowPlaying(genreId: nil, page: nil)
                .map { $0.results }
        case .trending:
            return repositoryProvider
                .movieRepository()
                .getPopular(genreId: nil, page: nil)
                .map { $0.results }
        }
    }
    
    private func combinePreviewDataWithBookmark(data: [Movie], bookmarkData: [BookmarkEntertainment]) -> [Movie] {
        return data.map { item in
            var newItem = item.copy()
            newItem.isBookmark = bookmarkData.map { $0.id }.contains(newItem.id)
            return newItem
        }
    }
    
    private func toggleBookmarkItem(with item: EntertainmentViewModel) -> Observable<Void> {
        let bookmarkEntertainment = BookmarkEntertainment(
            id: item.id,
            name: item.name,
            overview: item.overview,
            rating: item.rating,
            releaseDate: item.releaseDate,
            backdropPath: item.backdropURL?.path,
            posterPath: item.posterURL?.path,
            type: .movie,
            createAt: Date()
        )
        if !item.isBookmark {
            return repositoryProvider
                .entertainmentRepository()
                .saveBookmarkEntertainment(item: bookmarkEntertainment)
                .catch { _ in Observable.empty() }
        } else {
            return repositoryProvider
                .entertainmentRepository()
                .removeBookmarkEntertainment(item: bookmarkEntertainment)
                .catch { _ in Observable.empty() }
        }
    }
}
