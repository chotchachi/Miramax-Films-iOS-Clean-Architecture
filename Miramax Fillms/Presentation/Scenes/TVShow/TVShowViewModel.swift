//
//  TVShowViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import Domain

class TVShowViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let toSearchTrigger: Driver<Void>
        let retryGenreTrigger: Driver<Void>
        let retryBannerTrigger: Driver<Void>
        let retryUpcomingTrigger: Driver<Void>
        let retryPreviewTrigger: Driver<Void>
        let selectionEntertainmentTrigger: Driver<EntertainmentViewModel>
        let selectionGenreTrigger: Driver<Genre>
        let previewTabTrigger: Driver<TVShowPreviewTab>
        let seeMoreUpcomingTrigger: Driver<Void>
        let seeMorePreviewTrigger: Driver<Void>
        let toggleBookmarkTrigger: Driver<EntertainmentViewModel>
    }
    
    struct Output {
        let genresViewState: Driver<ViewState<Genre>>
        let bannerViewState: Driver<ViewState<EntertainmentViewModel>>
        let upcomingViewState: Driver<ViewState<EntertainmentViewModel>>
        let previewViewState: Driver<ViewState<EntertainmentViewModel>>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<TVShowRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<TVShowRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTrigger = trigger
            .take(1)
        
        let retryGenreTrigger = input.retryGenreTrigger
            .asObservable()
        
        let retryBannerTrigger = input.retryBannerTrigger
            .asObservable()
        
        let retryUpcomingTrigger = input.retryUpcomingTrigger
            .asObservable()
        
        let genresViewState = Observable.merge(viewTrigger, retryGenreTrigger)
            .flatMapLatest {
                self.repositoryProvider
                    .genreRepository()
                    .getGenreShowList()
                    .map { ViewState.success($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let bannerViewState = Observable.merge(viewTrigger, retryBannerTrigger)
            .flatMapLatest {
                self.repositoryProvider
                    .tvShowRepository()
                    .getAiringToday(genreId: nil, page: nil)
                    .map { response in response.results.map { $0.asPresentation() } }
                    .map { ViewState.success($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let upcomingViewState = Observable.merge(viewTrigger, retryUpcomingTrigger)
            .flatMapLatest {
                self.repositoryProvider
                    .tvShowRepository()
                    .getOnTheAir(genreId: nil, page: nil)
                    .map { response in response.results.map { $0.asPresentation() } }
                    .map { ViewState.success($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let bookmarkTVShowData = repositoryProvider
            .entertainmentRepository()
            .getAllBookmarkEntertainmentTVShow()
            .catchAndReturn([])
        
        let previewTabTrigger = input.previewTabTrigger
            .asObservable()
            .startWith(TVShowPreviewTab.defaultTab)
        
        let retryPreviewWithSelectedTab = input.retryPreviewTrigger
            .asObservable()
            .withLatestFrom(previewTabTrigger)
        
        let previewViewState = Observable.merge(previewTabTrigger, retryPreviewWithSelectedTab)
            .flatMapLatest { tab in
                return Observable.combineLatest(
                    self.getPreviewData(with: tab).asObservable(),
                    bookmarkTVShowData
                ) { self.combinePreviewDataWithBookmark(data: $0, bookmarkData: $1) }
                    .map { items in items.map { $0.asPresentation() } }
                    .map { ViewState.success($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        input.toggleBookmarkTrigger
            .asObservable()
            .flatMap {
                self.toggleBookmarkItem(with: $0)
                    .catch { _ in Completable.empty() }
            }
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
                self.router.trigger(.entertainmentList(responseRoute: .showUpcoming))
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
                    self.router.trigger(.entertainmentList(responseRoute: .showTopRating))
                case .news:
                    self.router.trigger(.entertainmentList(responseRoute: .showNews))
                case .trending:
                    self.router.trigger(.entertainmentList(responseRoute: .showTrending))
                }
            })
            .disposed(by: rx.disposeBag)
        
        return Output(genresViewState: genresViewState,
                      bannerViewState: bannerViewState,
                      upcomingViewState: upcomingViewState,
                      previewViewState: previewViewState)
    }
    
    private func getPreviewData(with tab: TVShowPreviewTab) -> Single<[TVShow]> {
        switch tab {
        case .topRating:
            return repositoryProvider
                .tvShowRepository()
                .getTopRated(genreId: nil, page: nil)
                .map { $0.results }
        case .news:
            return repositoryProvider
                .tvShowRepository()
                .getOnTheAir(genreId: nil, page: nil)
                .map { $0.results }
        case .trending:
            return repositoryProvider
                .tvShowRepository()
                .getPopular(genreId: nil, page: nil)
                .map { $0.results }
        }
    }
    
    private func combinePreviewDataWithBookmark(data: [TVShow], bookmarkData: [BookmarkEntertainment]) -> [TVShow] {
        return data.map { item in
            var newItem = item.copy()
            newItem.isBookmark = bookmarkData.map { $0.id }.contains(newItem.id)
            return newItem
        }
    }
    
    private func toggleBookmarkItem(with item: EntertainmentViewModel) -> Completable {
        let bookmarkEntertainment = BookmarkEntertainment(
            id: item.id,
            name: item.name,
            overview: item.overview,
            rating: item.rating,
            releaseDate: item.releaseDate,
            backdropPath: item.backdropURL?.path,
            posterPath: item.posterURL?.path,
            type: .tvShow,
            createAt: Date()
        )
        if !item.isBookmark {
            return repositoryProvider
                .entertainmentRepository()
                .saveBookmarkEntertainment(item: bookmarkEntertainment)
        } else {
            return repositoryProvider
                .entertainmentRepository()
                .removeBookmarkEntertainment(item: bookmarkEntertainment)
        }
    }
}
