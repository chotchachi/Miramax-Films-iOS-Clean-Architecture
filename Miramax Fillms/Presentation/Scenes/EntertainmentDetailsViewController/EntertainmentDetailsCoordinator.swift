//
//  EntertainmentDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import XCoordinator

enum EntertainmentDetailsRoute: Route {
    case initial(entertainment: EntertainmentModelType)
    case pop
    case search
    case seasonsList(seasons: [Season])
    case seasonDetails(season: Season)
    case personDetails(person: PersonModelType)
    case entertainmentDetails(entertainment: EntertainmentModelType)
}

class EntertainmentDetailsCoordinator: NavigationCoordinator<EntertainmentDetailsRoute> {
    
    private let appDIContainer: AppDIContainer
    private let entertainment: EntertainmentModelType
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, entertainment: EntertainmentModelType) {
        self.appDIContainer = appDIContainer
        self.entertainment = entertainment
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(entertainment: entertainment))
    }
    
    override func prepareTransition(for route: EntertainmentDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial(entertainment: let entertainment):
            let vc = EntertainmentDetailsViewController()
            vc.viewModel = EntertainmentDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, entertainmentModel: entertainment)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        case .search:
            addChild(SearchCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController))
            return .none()
        case .seasonsList(seasons: let seasons):
            addChild(SeasonsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, tvShowId: entertainment.entertainmentModelId, seasons: seasons))
            return .none()
        case .seasonDetails(season: let season):
            addChild(SeasonDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, tvShowId: entertainment.entertainmentModelId, season: season))
            return .none()
        case .personDetails(person: let person):
            addChild(PersonDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, personModel: person))
            return .none()
        case .entertainmentDetails(entertainment: let entertainment):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainment: entertainment))
            return .none()
        }
    }
}
