//
//  EntertainmentDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import XCoordinator
import Domain

enum EntertainmentDetailsRoute: Route {
    case initial(entertainment: EntertainmentModelType)
    case pop
    case search
    case share
    case seasonsList(seasons: [Season])
    case seasonDetails(season: Season)
    case personDetails(person: PersonModelType)
    case entertainmentDetails(entertainment: EntertainmentModelType)
    case recommendations
}

class EntertainmentDetailsCoordinator: NavigationCoordinator<EntertainmentDetailsRoute> {
    
    private let appDIContainer: AppDIContainer
    private let entertainment: EntertainmentModelType
    private let fromSearch: Bool
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, entertainment: EntertainmentModelType, fromSearch: Bool = false) {
        self.appDIContainer = appDIContainer
        self.entertainment = entertainment
        self.fromSearch = fromSearch
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
            if fromSearch {
                return .pop()
            } else {
                let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
                return .presentFullScreen(searchCoordinator, animation: .fade)
            }
        case .share:
            let typeStr = entertainment.entertainmentModelType == .movie ? "movie" : "tv"
            guard let url = URL(string: "https://www.themoviedb.org/\(typeStr)/\(entertainment.entertainmentModelId)") else {
                return .none()
            }
            let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                activity.popoverPresentationController?.sourceView = viewController.view
                activity.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 768, height: 300)
            }
            activity.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]
            return .present(activity)
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
        case .recommendations:
            addChild(EntertainmentListCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, responseRoute: .recommendations(entertainment: entertainment)))
            return .none()
        }
    }
}
