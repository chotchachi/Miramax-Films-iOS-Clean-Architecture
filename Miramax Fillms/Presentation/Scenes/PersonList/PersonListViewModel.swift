//
//  PersonListViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 14/10/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import Domain

typealias PersonListViewResult = (data: [PersonViewModel], isRefresh: Bool)

fileprivate struct QueryOptions {
    let query: String
    let page: Int
    let isRefresh: Bool
}

class PersonListViewModel: BaseViewModel, ViewModelType {
    
    struct Input {
        let popViewTrigger: Driver<Void>
        let toSearchTrigger: Driver<Void>
        let retryTrigger: Driver<Void>
        let refreshTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let personSelectTrigger: Driver<PersonViewModel>
    }
    
    struct Output {
        let viewResult: Driver<PersonListViewResult>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<PersonListRoute>
    private let query: String
    
    private var currentPage: Int = 1
    private var hasNextPage: Bool = false
    
    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<PersonListRoute>, query: String) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.query = query
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let refreshTrigger = input.refreshTrigger
            .asObservable()
            .map { QueryOptions(query: self.query, page: 1, isRefresh: true) }
                
        let loadMoreTrigger = input.loadMoreTrigger
            .asObservable()
            .filter { self.hasNextPage }
            .map { QueryOptions(query: self.query, page: self.currentPage + 1, isRefresh: false) }
        
        let queryOptions = Observable.merge(refreshTrigger, loadMoreTrigger)
            .startWith(QueryOptions(query: self.query, page: 1, isRefresh: true))
        
        let viewResult = queryOptions
            .flatMapLatest { options -> Observable<(data: [PersonViewModel], isRefresh: Bool)> in
                self.getPersonData(query: options.query, page: options.page)
                    .do(onSuccess: { [weak self] in
                        guard let self = self else { return }
                        self.currentPage = $0.page
                        self.hasNextPage = $0.page < $0.totalPages
                    })
                    .map { items in items.results.map { $0.asPresentation() } }
                    .map { ($0, options.isRefresh) }
                    .trackError(self.error)
                    .trackActivity(self.loading)
                    .retryWith(input.retryTrigger)
                    .catch { _ in Observable.empty() }
            }
            .scan(([], true)) { acc, change -> PersonListViewResult in
                if change.isRefresh {
                    return (change.data, change.isRefresh)
                } else {
                    return (acc.0 + change.data, change.isRefresh)
                }
            }
            .map { $0 as PersonListViewResult }
            .asDriverOnErrorJustComplete()
        
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
        
        input.personSelectTrigger
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.router.trigger(.personDetail(personId: item.id))
            })
            .disposed(by: rx.disposeBag)
        
        return Output(
            viewResult: viewResult
        )
    }
    
    private func getPersonData(query: String, page: Int) -> Single<BaseResponse<Person>> {
        return repositoryProvider
            .searchRepository()
            .searchPerson(query: query, page: page)
    }
}
