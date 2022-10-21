//
//  SelfiePreviewCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/10/2022.
//

import XCoordinator
import UIKit
import Domain

enum SelfiePreviewRoute: Route {
    case initial
    case pop
}

class SelfiePreviewCoordinator: NavigationCoordinator<SelfiePreviewRoute> {
    private let appDIContainer: AppDIContainer
    private let finalImage: UIImage
    private let selfieFrame: SelfieFrame?
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, finalImage: UIImage, selfieFrame: SelfieFrame?) {
        self.appDIContainer = appDIContainer
        self.finalImage = finalImage
        self.selfieFrame = selfieFrame
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial)
    }
    
    override func prepareTransition(for route: SelfiePreviewRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = SelfiePreviewViewController()
            vc.viewModel = SelfiePreviewViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, finalImage: finalImage, selfieFrame: selfieFrame)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .popToRoot()
        }
    }
}
