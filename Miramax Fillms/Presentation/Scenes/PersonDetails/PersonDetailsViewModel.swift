//
//  PersonDetailsViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

class PersonDetailsViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let shareTrigger: Driver<Void>
        let toBiographyTrigger: Driver<Void>
        let entertainmentSelectTrigger: Driver<EntertainmentViewModel>
        let toggleBookmarkTrigger: Driver<Void>
        let viewImageTrigger: Driver<(UIView, UIImage)>
    }
    
    struct Output {
        let personViewModel: Driver<PersonViewModel>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<PersonDetailsRoute>
    private let personId: Int

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<PersonDetailsRoute>, personId: Int) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.personId = personId
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let personData = trigger
            .take(1)
            .flatMapLatest {
                self.repositoryProvider
                    .personRepository()
                    .getPersonDetail(personId: self.personId)
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .retryWith(input.retryTrigger)
                    .catch { _ in Observable.empty() }
            }
        
        let bookmarkPersonsData = repositoryProvider
            .personRepository()
            .getBookmarkPersons()
            .catchAndReturn([])
        
        let personWithBookmark = Observable.combineLatest(personData, bookmarkPersonsData) { person, bookmarkPersons -> Person in
            var newPerson = person.copy()
            newPerson.isBookmark = bookmarkPersons.map { $0.id }.contains(newPerson.id)
            return newPerson
        }
        
        let personViewModel = personWithBookmark
            .map { $0.asPresentation() }
            .take(1)
            .asDriverOnErrorJustComplete()
        
        input.toggleBookmarkTrigger
            .asObservable()
            .withLatestFrom(personWithBookmark)
            .flatMap {
                self.toggleBookmarkPerson(with: $0)
                    .catch { _ in Completable.empty() }
            }
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
        
        input.shareTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.share)
            })
            .disposed(by: rx.disposeBag)
        
        input.toBiographyTrigger
            .asObservable()
            .withLatestFrom(personData)
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.biography(person: item))
            })
            .disposed(by: rx.disposeBag)
        
        input.entertainmentSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.entertainmentDetail(entertainmentId: item.id, entertainmentType: item.type))
            })
            .disposed(by: rx.disposeBag)
        
        input.viewImageTrigger
            .drive(onNext: { [weak self] tuple in
                guard let self = self else { return }
                self.router.trigger(.viewImage(image: tuple.1, sourceView: tuple.0))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(personViewModel: personViewModel)
    }
    
    private func toggleBookmarkPerson(with item: Person) -> Completable {
        let bookmarkPerson = BookmarkPerson(
            id: item.id,
            name: item.name,
            profilePath: item.profilePath,
            birthday: item.birthday,
            biography: item.biography,
            createAt: Date()
        )
        if !item.isBookmark {
            return repositoryProvider
                .personRepository()
                .saveBookmarkPerson(item: bookmarkPerson)
        } else {
            return repositoryProvider
                .personRepository()
                .removeBookmarkPerson(item: bookmarkPerson)
        }
    }
}
