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
        let selectionEntertainmentTrigger: Driver<EntertainmentModelType>
        let selectionGenreTrigger: Driver<Genre>
        let previewTabTrigger: Driver<TVShowPreviewTab>
        let seeMoreUpcomingTrigger: Driver<Void>
        let seeMorePreviewTrigger: Driver<Void>
    }
    
    struct Output {
        let genresViewState: Driver<ViewState<Genre>>
        let bannerViewState: Driver<ViewState<TVShow>>
        let upcomingViewState: Driver<ViewState<TVShow>>
        let previewViewState: Driver<ViewState<TVShow>>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<TVShowRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<TVShowRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTriggerO = trigger
            .take(1)
        
        let retryGenreTriggerO = input.retryGenreTrigger
            .asObservable()
        
        let retryBannerTriggerO = input.retryBannerTrigger
            .asObservable()
        
        let retryUpcomingTriggerO = input.retryUpcomingTrigger
            .asObservable()
        
        let genresViewStateD = Observable.merge(viewTriggerO, retryGenreTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .genreRepository()
                    .getGenreShowList()
                    .map { ViewState.success($0) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let bannerViewStateD = Observable.merge(viewTriggerO, retryBannerTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .tvShowRepository()
                    .getAiringToday(genreId: nil, page: nil)
                    .map { ViewState.success($0.results) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let upcomingViewStateD = Observable.merge(viewTriggerO, retryUpcomingTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .tvShowRepository()
                    .getOnTheAir(genreId: nil, page: nil)
                    .map { ViewState.success($0.results) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        let previewTabTriggerO = input.previewTabTrigger
            .asObservable()
            .startWith(TVShowPreviewTab.defaultTab)
        
        let retryPreviewWithSelectedTabO = input.retryPreviewTrigger
            .asObservable()
            .withLatestFrom(previewTabTriggerO)
        
        let previewViewStateD = Observable.merge(previewTabTriggerO, retryPreviewWithSelectedTabO)
            .flatMapLatest { tab in
                self.getPreviewData(with: tab)
                    .map { ViewState.success($0.results) }
                    .catchAndReturn(.error)
            }
            .asDriverOnErrorJustComplete()
        
        input.toSearchTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.search)
            })
            .disposed(by: rx.disposeBag)
        
        input.selectionEntertainmentTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentDetail(entertainmentId: item.entertainmentModelId, entertainmentType: item.entertainmentModelType))
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
            .withLatestFrom(previewTabTriggerO.asDriverOnErrorJustComplete())
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
        
        return Output(genresViewState: genresViewStateD,
                      bannerViewState: bannerViewStateD,
                      upcomingViewState: upcomingViewStateD,
                      previewViewState: previewViewStateD)
    }
    
    private func getPreviewData(with tab: TVShowPreviewTab) -> Observable<BaseResponse<TVShow>> {
        switch tab {
        case .topRating:
            return repositoryProvider
                .tvShowRepository()
                .getTopRated(genreId: nil, page: nil)
                .asObservable()
        case .news:
            return repositoryProvider
                .tvShowRepository()
                .getOnTheAir(genreId: nil, page: nil)
                .asObservable()
        case .trending:
            return repositoryProvider
                .tvShowRepository()
                .getPopular(genreId: nil, page: nil)
                .asObservable()
        }
    }
}