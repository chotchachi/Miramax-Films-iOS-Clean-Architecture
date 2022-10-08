//
//  PersonDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import XCoordinator
import Domain

enum PersonDetailsRoute: Route {
    case initial(personModel: PersonModelType)
    case pop
    case search
    case share
    case biography(personDetail: PersonDetail)
    case entertainmentDetails(entertainment: EntertainmentModelType)
}

class PersonDetailsCoordinator: NavigationCoordinator<PersonDetailsRoute> {
    
    private let appDIContainer: AppDIContainer
    private let personModel: PersonModelType
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, personModel: PersonModelType) {
        self.appDIContainer = appDIContainer
        self.personModel = personModel
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(personModel: personModel))
    }
    
    override func prepareTransition(for route: PersonDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial(personModel: let personModel):
            let vc = PersonDetailsViewController()
            vc.viewModel = PersonDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, personModel: personModel)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        case .search:
            let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
            return .presentFullScreen(searchCoordinator, animation: .fade)
        case .share:
            guard let url = URL(string: "https://www.themoviedb.org/person/\(personModel.personModelId)") else {
                return .none()
            }
            let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                activity.popoverPresentationController?.sourceView = viewController.view
                activity.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 768, height: 300)
            }
            activity.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]
            return .present(activity)
        case .biography(personDetail: let personDetail):
            addChild(PersonBiographyCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, personDetail: personDetail))
            return .none()
        case .entertainmentDetails(entertainment: let entertainment):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainment: entertainment))
            return .none()
        }
    }
}
