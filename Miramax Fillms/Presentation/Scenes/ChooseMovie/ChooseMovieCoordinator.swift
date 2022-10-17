//
//  ChooseMovieCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/10/2022.
//

import XCoordinator
import Domain

enum ChooseMovieRoute: Route {
    case initial
    case pop
}

class ChooseMovieCoordinator: NavigationCoordinator<ChooseMovieRoute> {
    private let appDIContainer: AppDIContainer
//    private let selfieFrame: SelfieFrame
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController) {
        self.appDIContainer = appDIContainer
//        self.selfieFrame = selfieFrame
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial)
    }
    
    override func prepareTransition(for route: ChooseMovieRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = ChooseMovieViewController()
            vc.viewModel = ChooseMovieViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        }
    }
}
