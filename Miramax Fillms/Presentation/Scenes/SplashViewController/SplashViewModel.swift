//
//  SplashViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import XCoordinator

class SplashViewModel: BaseViewModel {
    private let router: UnownedRouter<AppRoute>
    
    init(router: UnownedRouter<AppRoute>) {
        self.router = router
    }
    
}
