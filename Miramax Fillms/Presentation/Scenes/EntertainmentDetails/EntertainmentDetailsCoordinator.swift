//
//  EntertainmentDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import XCoordinator
import Domain

enum EntertainmentDetailsRoute: Route {
    case initial
    case pop
    case search
    case share
    case seasonsList(seasons: [Season])
    case seasonDetail(seasonNumber: Int)
    case personDetail(personId: Int)
    case entertainmentDetail(entertainmentId: Int, entertainmentType: EntertainmentType)
    case recommendations
    case viewImage(image: UIImage, sourceView: UIView)
}

class EntertainmentDetailsCoordinator: NavigationCoordinator<EntertainmentDetailsRoute> {
    
    private let appDIContainer: AppDIContainer
    private let entertainmentId: Int
    private let entertainmentType: EntertainmentType
    private let fromSearch: Bool
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, entertainmentId: Int, entertainmentType: EntertainmentType, fromSearch: Bool = false) {
        self.appDIContainer = appDIContainer
        self.entertainmentId = entertainmentId
        self.entertainmentType = entertainmentType
        self.fromSearch = fromSearch
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial)
    }
    
    override func prepareTransition(for route: EntertainmentDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = EntertainmentDetailsViewController()
            vc.viewModel = EntertainmentDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, entertainmentId: entertainmentId, entertainmentType: entertainmentType)
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
            let typeStr = entertainmentType == .movie ? "movie" : "tv"
            guard let url = URL(string: "https://www.themoviedb.org/\(typeStr)/\(entertainmentId)") else {
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
            addChild(SeasonsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, tvShowId: entertainmentId, seasons: seasons))
            return .none()
        case .seasonDetail(seasonNumber: let seasonNumber):
            addChild(SeasonDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, tvShowId: entertainmentId, seasonNumber: seasonNumber))
            return .none()
        case .personDetail(personId: let personId):
            addChild(PersonDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, personId: personId))
            return .none()
        case .entertainmentDetail(entertainmentId: let entertainmentId, entertainmentType: let entertainmentType):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainmentId: entertainmentId, entertainmentType: entertainmentType))
            return .none()
        case .recommendations:
            addChild(EntertainmentListCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, responseRoute: .recommendations(entertainmentId: entertainmentId, entertainmentType: entertainmentType)))
            return .none()
        case .viewImage(image: let image, sourceView: let sourceView):
            let imageInfo = GSImageInfo(image: image, imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: sourceView)
            let imageViewer = ImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            return .present(imageViewer)
        }
    }
}
