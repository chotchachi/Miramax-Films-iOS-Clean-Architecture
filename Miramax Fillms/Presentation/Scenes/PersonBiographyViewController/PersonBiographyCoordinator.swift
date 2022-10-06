//
//  PersonBiographyCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import XCoordinator
import Domain

enum PersonBiographyRoute: Route {
    case initial(personDetail: PersonDetail)
    case pop
    case search
    case share
}

class PersonBiographyCoordinator: NavigationCoordinator<PersonBiographyRoute> {
    
    private let appDIContainer: AppDIContainer
    private let personDetail: PersonDetail

    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, personDetail: PersonDetail) {
        self.appDIContainer = appDIContainer
        self.personDetail = personDetail
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(personDetail: personDetail))
    }
    
    override func prepareTransition(for route: PersonBiographyRoute) -> NavigationTransition {
        switch route {
        case .initial(personDetail: let personDetail):
            let vc = PersonBiographyViewController()
            vc.viewModel = PersonBiographyViewModel(router: unownedRouter, personDetail: personDetail)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        case .search:
            let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
            return .presentFullScreen(searchCoordinator, animation: .fade)
        case .share:
            guard let url = URL(string: "https://www.themoviedb.org/person/\(personDetail.id)") else {
                return .none()
            }
            let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                activity.popoverPresentationController?.sourceView = viewController.view
                activity.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 768, height: 300)
            }
            activity.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]
            return .present(activity)
        }
    }
}
