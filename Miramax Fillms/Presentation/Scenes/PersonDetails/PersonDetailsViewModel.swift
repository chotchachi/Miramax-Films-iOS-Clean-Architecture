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
    }
    
    struct Output {
        let person: Driver<Person>
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
        let viewTriggerO = trigger
            .take(1)
        
        let retryTriggerO = input.retryTrigger
            .asObservable()
        
        let bookmarkPersonsO = repositoryProvider
            .personRepository()
            .getBookmarkPersons()
            .catchAndReturn([])
        
        let personO = Observable.merge(viewTriggerO, retryTriggerO)
            .flatMapLatest {
                self.repositoryProvider
                    .personRepository()
                    .getPersonDetail(personId: self.personId)
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .catch { _ in Observable.empty() }
            }
        
        let personWithBookmarkO = Observable.combineLatest(personO, bookmarkPersonsO) { person, bookmarkPersons -> Person in
            var newPerson = person.copy()
            newPerson.isBookmark = bookmarkPersons.map { $0.id }.contains(newPerson.id)
            return newPerson
        }
        
        let personWithBookmarkD = personWithBookmarkO
            .take(1)
            .asDriverOnErrorJustComplete()
        
        input.toggleBookmarkTrigger
            .asObservable()
            .withLatestFrom(personWithBookmarkO)
            .flatMapLatest { self.toggleBookmarkPerson(with: $0) }
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
            .withLatestFrom(personO.asDriverOnErrorJustComplete())
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
        
        return Output(person: personWithBookmarkD)
    }
    
    private func toggleBookmarkPerson(with item: Person) -> Observable<Void> {
        let bookmarkPerson = BookmarkPerson(id: item.id, name: item.name, profilePath: item.profilePath, birthday: item.birthday, biography: item.biography, createAt: Date())
        if !item.isBookmark {
            return repositoryProvider
                .personRepository()
                .saveBookmarkPerson(item: bookmarkPerson)
                .catch { _ in Observable.empty() }
        } else {
            return repositoryProvider
                .personRepository()
                .removeBookmarkPerson(item: bookmarkPerson)
                .catch { _ in Observable.empty() }
        }
    }
}
