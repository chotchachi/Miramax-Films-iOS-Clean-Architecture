//
//  PersonDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import XCoordinator
import Domain

enum PersonDetailsRoute: Route {
    case initial(personId: Int)
    case pop
    case search
    case share
    case biography(person: Person)
    case entertainmentDetails(entertainment: EntertainmentModelType)
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
        trigger(.initial(personId: personId))
    }
    
    override func prepareTransition(for route: PersonDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial(personId: let personId):
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
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                activity.popoverPresentationController?.sourceView = viewController.view
                activity.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 768, height: 300)
            }
            activity.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]
            return .present(activity)
        case .biography(person: let person):
            addChild(PersonBiographyCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, person: person))
            return .none()
        case .entertainmentDetails(entertainment: let entertainment):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainment: entertainment))
            return .none()
        }
    }
}
