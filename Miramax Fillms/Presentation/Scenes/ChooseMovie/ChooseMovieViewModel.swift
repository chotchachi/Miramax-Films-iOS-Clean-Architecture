//
//  ChooseMovieViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/10/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import Domain

class ChooseMovieViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let dismissTrigger: Driver<Void>
        let searchTrigger: Driver<String?>
    }
    
    struct Output {
        
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfieMovieRoute>

    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfieMovieRoute>) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        
        return Output()
    }
}
