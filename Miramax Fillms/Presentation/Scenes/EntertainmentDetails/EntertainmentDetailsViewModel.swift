//
//  EntertainmentDetailsViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

class EntertainmentDetailsViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let toSeasonListTrigger: Driver<Void>
        let seasonSelectTrigger: Driver<Season>
        let castSelectTrigger: Driver<PersonViewModel>
        let entertainmentSelectTrigger: Driver<EntertainmentViewModel>
        let shareTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let seeMoreRecommendTrigger: Driver<Void>
        let toggleBookmarkTrigger: Driver<Void>
        let viewImageTrigger: Driver<(UIView, UIImage)>
    }
    
    struct Output {
        let entertainmentViewModel: Driver<EntertainmentViewModel>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<EntertainmentDetailsRoute>
    private let entertainmentId: Int
    private let entertainmentType: EntertainmentType

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<EntertainmentDetailsRoute>, entertainmentId: Int, entertainmentType: EntertainmentType) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.entertainmentId = entertainmentId
        self.entertainmentType = entertainmentType
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let entertainmentData = trigger
            .take(1)
            .flatMapLatest {
                self.getEntertainmentDetails()
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .retryWith(input.retryTrigger)
                    .catch { _ in Observable.empty() }
            }

        let bookmarkEntertainmentData = repositoryProvider
            .entertainmentRepository()
            .getAllBookmarkEntertainment()
            .catchAndReturn([])
        
        let entertainmentWithBookmark = Observable.combineLatest(entertainmentData, bookmarkEntertainmentData) { entertainment, bookmarkEntertainment -> Any? in
            if let movie = entertainment as? Movie {
                var newMovie = movie.copy()
                newMovie.isBookmark = bookmarkEntertainment.filter { $0.type == .movie }.map { $0.id }.contains(newMovie.id)
                return newMovie
            } else if let tvShow = entertainment as? TVShow {
                var newTVShow = tvShow.copy()
                newTVShow.isBookmark = bookmarkEntertainment.filter { $0.type == .tvShow }.map { $0.id }.contains(newTVShow.id)
                return newTVShow
            } else {
                return nil
            }
        }

        let entertainmentViewModel = entertainmentWithBookmark
            .compactMap { item -> EntertainmentViewModel? in
                if let movie = item as? Movie {
                    return movie.asPresentation()
                } else if let tvShow = item as? TVShow {
                    return tvShow.asPresentation()
                } else {
                    return nil
                }
            }
            .take(1)
            .asDriverOnErrorJustComplete()
        
        input.toggleBookmarkTrigger
            .asObservable()
            .withLatestFrom(entertainmentWithBookmark)
            .compactMap { $0 }
            .flatMapLatest { self.toggleBookmarkEntertainment(with: $0) }
            .subscribe()
            .disposed(by: rx.disposeBag)
        
        input.viewImageTrigger
            .drive(onNext: { [weak self] tuple in
                guard let self = self else { return }
                self.router.trigger(.viewImage(image: tuple.1, sourceView: tuple.0))
            })
            .disposed(by: rx.disposeBag)
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        input.toSearchTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.search)
            })
            .disposed(by: rx.disposeBag)
        
        input.toSeasonListTrigger
            .asObservable()
            .withLatestFrom(entertainmentData)
            .compactMap { $0 as? TVShow }
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                if let seasons = item.seasons {
                    self.router.trigger(.seasonsList(seasons: seasons))
                }
            })
            .disposed(by: rx.disposeBag)
        
        input.seasonSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.seasonDetail(seasonNumber: item.seasonNumber))
            })
            .disposed(by: rx.disposeBag)
        
        input.castSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.personDetail(personId: item.id))
            })
            .disposed(by: rx.disposeBag)
        
        input.entertainmentSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentDetail(entertainmentId: item.id, entertainmentType: item.type))
            })
            .disposed(by: rx.disposeBag)
        
        input.shareTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.share)
            })
            .disposed(by: rx.disposeBag)
        
        input.seeMoreRecommendTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.recommendations)
            })
            .disposed(by: rx.disposeBag)
        
        return Output(entertainmentViewModel: entertainmentViewModel)
    }
    
    private func getEntertainmentDetails() -> Single<Any> {
        switch entertainmentType {
        case .movie:
            return repositoryProvider
                .movieRepository()
                .getDetail(movieId: entertainmentId)
                .map { $0 as Any}
        case .tvShow:
            return repositoryProvider
                .tvShowRepository()
                .getDetail(tvShowId: entertainmentId)
                .map { $0 as Any}
        }
    }
    
    private func toggleBookmarkEntertainment(with item: Any) -> Observable<Void> {
        var bookmarkEntertainment: BookmarkEntertainment!
        var isBookmark: Bool!
        if let movie = item as? Movie {
            bookmarkEntertainment = BookmarkEntertainment(
                id: movie.id,
                name: movie.title,
                overview: movie.overview,
                rating: movie.voteAverage,
                releaseDate: movie.releaseDate,
                backdropPath: movie.backdropURL?.path,
                posterPath: movie.posterURL?.path,
                type: .movie,
                createAt: Date()
            )
            isBookmark = movie.isBookmark
        } else if let tvShow = item as? TVShow {
            bookmarkEntertainment = BookmarkEntertainment(
                id: tvShow.id,
                name: tvShow.name,
                overview: tvShow.overview,
                rating: tvShow.voteAverage,
                releaseDate: tvShow.firstAirDate,
                backdropPath: tvShow.backdropURL?.path,
                posterPath: tvShow.posterURL?.path,
                type: .tvShow,
                createAt: Date()
            )
            isBookmark = tvShow.isBookmark
        } else {
            return Observable.just(())
        }
        if !isBookmark {
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
