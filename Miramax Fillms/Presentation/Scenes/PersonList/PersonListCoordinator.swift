////
////  PersonListCoordinator.swift
////  Miramax Fillms
////
////  Created by Thanh Quang on 14/10/2022.
////
//
//import XCoordinator
//import Domain
//
//enum PersonListRoute: Route {
//    case initial(query: String)
//    case pop
//    case search
//    case personDetail(personId: Int)
//}
//
//class PersonListCoordinator: NavigationCoordinator<PersonListRoute> {
//    
//    private let appDIContainer: AppDIContainer
//    private let fromSearch: Bool
//
//    public override var viewController: UIViewController! {
//        return autoreleaseController
//    }
//    
//    private weak var autoreleaseController: UIViewController?
//
//    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, responseRoute: EntertainmentsResponseRoute, fromSearch: Bool = false) {
//        self.appDIContainer = appDIContainer
//        self.fromSearch = fromSearch
//        super.init(rootViewController: rootViewController, initialRoute: nil)
//        trigger(.initial(responseRoute: responseRoute))
//    }
//    
//    override func prepareTransition(for route: PersonListRoute) -> NavigationTransition {
//        switch route {
//        case .initial(responseRoute: let responseRoute):
//            let vc = EntertainmentListViewController()
//            vc.viewModel = EntertainmentListViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, responseRoute: responseRoute)
//            autoreleaseController = vc
//            return .push(vc)
//        case .pop:
//            return .pop()
//        case .search:
//            if fromSearch {
//                return .pop()
//            } else {
//                let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
//                return .presentFullScreen(searchCoordinator, animation: .fade)
//            }
//        case .personDetail(personId: let personId):
//            addChild(PersonDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, personId: personId, fromSearch: true))
//            return .none()
//        }
//    }
//}
