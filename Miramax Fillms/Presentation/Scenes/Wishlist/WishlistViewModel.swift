//
//  WishlistViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

enum WishlistViewItem {
    case movie(item: BookmarkEntertainment)
    case tvShow(item: BookmarkEntertainment)
    case actor(item: BookmarkPerson)
}

class WishlistViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let toSearchTrigger: Driver<Void>
        let previewTabTrigger: Driver<WishlistPreviewTab>
        let removeAllTrigger: Driver<Void>
        let wishlistItemSelectionTrigger: Driver<WishlistViewItem>
    }
    
    struct Output {
        let wishlistViewData: Driver<[WishlistViewItem]>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<WishlistRoute>
    
    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<WishlistRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let viewTriggerO = trigger
            .take(1)
        
        let previewTabTriggerO = viewTriggerO
            .flatMapLatest {
                input.previewTabTrigger
                    .asObservable()
                    .startWith(WishlistPreviewTab.defaultTab)
            }
        
        let wishlistViewDataD = previewTabTriggerO
            .flatMapLatest {
                self.getPreviewData(with: $0)
                    .catchAndReturn([])
            }
            .asDriverOnErrorJustComplete()
        
        input.removeAllTrigger
            .asObservable()
            .withLatestFrom(previewTabTriggerO)
            .flatMapLatest {
                self.removeAllWishlist(with: $0)
                    .catch { _ in Observable.empty() }
            }
            .subscribe()
            .disposed(by: rx.disposeBag)
        
        input.toSearchTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.search)
            })
            .disposed(by: rx.disposeBag)
        
        input.wishlistItemSelectionTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                switch item {
                case .movie(item: let item):
                    self.router.trigger(.entertainmentDetail(entertainmentId: item.entertainmentModelId, entertainmentType: item.entertainmentModelType))
                case .tvShow(item: let item):
                    self.router.trigger(.entertainmentDetail(entertainmentId: item.entertainmentModelId, entertainmentType: item.entertainmentModelType))
                case .actor(item: let item):
                    self.router.trigger(.personDetail(personId: item.id))
                }
            })
            .disposed(by: rx.disposeBag)
        
        return Output(wishlistViewData: wishlistViewDataD)
    }
    
    private func getPreviewData(with tab: WishlistPreviewTab) -> Observable<[WishlistViewItem]> {
        switch tab {
        case .movies:
            return repositoryProvider
                .entertainmentRepository()
                .getAllBookmarkEntertainmentMovie()
                .map { items in items.map { WishlistViewItem.movie(item: $0) } }
        case .shows:
            return repositoryProvider
                .entertainmentRepository()
                .getAllBookmarkEntertainmentTVShow()
                .map { items in items.map { WishlistViewItem.tvShow(item: $0) } }
        case .actors:
            return repositoryProvider
                .personRepository()
                .getBookmarkPersons()
                .map { items in items.map { WishlistViewItem.actor(item: $0) } }
        }
    }
    
    private func removeAllWishlist(with tab: WishlistPreviewTab) -> Observable<Void> {
        switch tab {
        case .movies:
            return repositoryProvider
                .entertainmentRepository()
                .removeAllBookmarkEntertainmentMovie()
        case .shows:
            return repositoryProvider
                .entertainmentRepository()
                .removeAllBookmarkEntertainmentTVShow()
        case .actors:
            return repositoryProvider
                .personRepository()
                .removeAllBookmarkPerson()
        }
    }
}
