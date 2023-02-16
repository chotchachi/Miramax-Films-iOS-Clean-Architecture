//
//  PersonDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import XCoordinator
import Domain

enum PersonDetailsRoute: Route {
    case initial
    case pop
    case search
    case share
    case biography(person: Person)
    case entertainmentDetail(entertainmentId: Int, entertainmentType: EntertainmentType)
    case viewImage(image: UIImage, sourceView: UIView)
}

class PersonDetailsCoordinator: NavigationCoordinator<PersonDetailsRoute> {
    
    private let appDIContainer: AppDIContainer
    private let personId: Int
    private let fromSearch: Bool

    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, personId: Int, fromSearch: Bool = false) {
        self.appDIContainer = appDIContainer
        self.personId = personId
        self.fromSearch = fromSearch
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial)
    }
    
    override func prepareTransition(for route: PersonDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = PersonDetailsViewController()
            vc.viewModel = PersonDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, personId: personId)
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
            guard let url = URL(string: "https://www.themoviedb.org/person/\(personId)") else {
                return .none()
            }
            let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                activity.popoverPresentationController?.sourceView = viewController.view
                activity.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 768, height: 300)
            }
            activity.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]
            return .present(activity)
        case .biography(person: let person):
            addChild(PersonBiographyCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, person: person))
            return .none()
        case .entertainmentDetail(entertainmentId: let entertainmentId, entertainmentType: let entertainmentType):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainmentId: entertainmentId, entertainmentType: entertainmentType))
            return .none()
        case .viewImage(image: let image, sourceView: let sourceView):
            let imageInfo = GSImageInfo(image: image, imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: sourceView)
            let imageViewer = ImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            return .present(imageViewer)
        }
    }
}
