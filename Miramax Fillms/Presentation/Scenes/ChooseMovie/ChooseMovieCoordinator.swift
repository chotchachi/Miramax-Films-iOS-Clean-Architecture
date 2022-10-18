//
//  ChooseMovieCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/10/2022.
//

import XCoordinator
import UIKit
import Domain

enum ChooseMovieRoute: Route {
    case initial
    case pop
    case done(movieImage: UIImage)
}

class ChooseMovieCoordinator: NavigationCoordinator<ChooseMovieRoute> {
    private let appDIContainer: AppDIContainer
    private let selfieFrame: SelfieFrame?
    private let callback: SelectMovieCallback?
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, selfieFrame: SelfieFrame? = nil, callback: SelectMovieCallback? = nil) {
        self.appDIContainer = appDIContainer
        self.selfieFrame = selfieFrame
        self.callback = callback
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
        case .done(movieImage: let movieImage):
            if let callback = callback {
                callback(movieImage)
                return .pop()
            } else {
                addChild(SelfieCameraCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, selfieFrame: selfieFrame!, movieImage: movieImage))
                return .none()
            }
        }
    }
}
