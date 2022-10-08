//
//  PersonBiographyCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import XCoordinator
import Domain

enum PersonBiographyRoute: Route {
    case initial(person: Person)
    case pop
    case search
    case share
}

class PersonBiographyCoordinator: NavigationCoordinator<PersonBiographyRoute> {
    
    private let appDIContainer: AppDIContainer
    private let person: Person

    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, person: Person) {
        self.appDIContainer = appDIContainer
        self.person = person
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(person: person))
    }
    
    override func prepareTransition(for route: PersonBiographyRoute) -> NavigationTransition {
        switch route {
        case .initial(person: let person):
            let vc = PersonBiographyViewController()
            vc.viewModel = PersonBiographyViewModel(router: unownedRouter, person: person)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        case .search:
            let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
            return .presentFullScreen(searchCoordinator, animation: .fade)
        case .share:
            guard let url = URL(string: "https://www.themoviedb.org/person/\(person.id)") else {
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
