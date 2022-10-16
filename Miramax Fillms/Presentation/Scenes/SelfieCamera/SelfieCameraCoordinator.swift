//
//  SelfieCameraCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/10/2022.
//

import XCoordinator
import Domain

enum SelfieCameraRoute: Route {
    case initial
    case pop
}

class SelfieCameraCoordinator: NavigationCoordinator<SelfieCameraRoute> {
    private let appDIContainer: AppDIContainer
    private let selfieFrame: SelfieFrame
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, selfieFrame: SelfieFrame) {
        self.appDIContainer = appDIContainer
        self.selfieFrame = selfieFrame
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial)
    }
    
    override func prepareTransition(for route: SelfieCameraRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = SelfieCameraViewController()
            vc.viewModel = SelfieCameraViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, selfieFrame: selfieFrame)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        }
    }
}
