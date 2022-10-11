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
    }
    
    struct Output {
        let entertainment: Driver<EntertainmentViewModel>
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
        let viewTriggerO = trigger
            .take(1)
        
        let retryTriggerO = input.retryTrigger
            .asObservable()
        
        let bookmarkEntertainmentO = repositoryProvider
            .entertainmentRepository()
            .getAllBookmarkEntertainment()
            .catchAndReturn([])
        
        let entertainmentD = Observable.merge(viewTriggerO, retryTriggerO)
            .flatMapLatest {
                self.getEntertainmentDetails()
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .catch { _ in Observable.empty() }
            }
            .asDriverOnErrorJustComplete()

//        let entertainmentWithBookmarkO = Observable.combineLatest(entertainmentO, bookmarkEntertainmentO) { entertainment, bookmarkEntertainment -> Ent in
//            var newPerson = person.copy()
//            newPerson.isBookmark = bookmarkPersons.map { $0.id }.contains(newPerson.id)
//            return newPerson
//        }
//
//        let personWithBookmarkD = personWithBookmarkO
//            .take(1)
//            .asDriverOnErrorJustComplete()
        
        input.toggleBookmarkTrigger
            .asObservable()
            .withLatestFrom(entertainmentD)
            .flatMapLatest { self.toggleBookmarkEntertainment(with: $0) }
            .subscribe()
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
            .withLatestFrom(entertainmentD)
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
        
        return Output(entertainment: entertainmentD)
    }
    
    private func getEntertainmentDetails() -> Single<EntertainmentViewModel> {
        switch entertainmentType {
        case .movie:
            return repositoryProvider
                .movieRepository()
                .getDetail(movieId: entertainmentId)
                .map { $0.asPresentation() }
        case .tvShow:
            return repositoryProvider
                .tvShowRepository()
                .getDetail(tvShowId: entertainmentId)
                .map { $0.asPresentation() }
        }
    }
    
    private func toggleBookmarkEntertainment(with item: EntertainmentViewModel) -> Observable<Void> {
        let bookmarkEntertainment = BookmarkEntertainment(
            id: item.id,
            name: item.name,
            overview: item.overview,
            rating: item.rating,
            releaseDate: item.releaseDate,
            backdropPath: item.backdropURL?.path,
            posterPath: item.posterURL?.path,
            type: item.type,
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
