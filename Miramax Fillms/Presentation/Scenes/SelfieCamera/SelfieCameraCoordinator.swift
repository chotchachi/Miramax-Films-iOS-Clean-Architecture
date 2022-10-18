//
//  SelfieCameraCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/10/2022.
//

import XCoordinator
import UIKit
import Domain

typealias SelectMovieCallback = (UIImage) -> Void

enum SelfieCameraRoute: Route {
    case initial
    case pop
    case selectMovieImage(callback: SelectMovieCallback)
}

class SelfieCameraCoordinator: NavigationCoordinator<SelfieCameraRoute> {
    private let appDIContainer: AppDIContainer
    private let selfieFrame: SelfieFrame
    private let movieImage: UIImage
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, selfieFrame: SelfieFrame, movieImage: UIImage) {
        self.appDIContainer = appDIContainer
        self.selfieFrame = selfieFrame
        self.movieImage = movieImage
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial)
    }
    
    override func prepareTransition(for route: SelfieCameraRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = SelfieCameraViewController()
            vc.viewModel = SelfieCameraViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, selfieFrame: selfieFrame, movieImage: movieImage)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        case .selectMovieImage(callback: let callback):
            addChild(ChooseMovieCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, callback: callback))
            return .none()
        }
    }
}
