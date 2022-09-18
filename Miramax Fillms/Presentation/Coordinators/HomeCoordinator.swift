//
//  HomeCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import XCoordinator

enum HomeTabRoute: Route {
    case movie
//    case tvShow
//    case geners
//    case wishlist
//    case setting
}

class HomeCoordinator: TabBarCoordinator<HomeTabRoute> {
    private let movieRoute: StrongRouter<MovieRoute>
    
    convenience init(appDIContainer: AppDIContainer) {
        let movieCoordinator = MovieCoordinator(appDIContainer: appDIContainer)
        movieCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)

        self.init(movieRoute: movieCoordinator.strongRouter)
    }
    
    init(
        movieRoute: StrongRouter<MovieRoute>
    ) {
        self.movieRoute = movieRoute
        
        super.init(tabs: [movieRoute], select: movieRoute)
    }
    
    override func prepareTransition(for route: HomeTabRoute) -> TabBarTransition {
        switch route {
        case .movie:
            return .select(movieRoute)
//        case .tvShow:
//            <#code#>
//        case .geners:
//            <#code#>
//        case .wishlist:
//            <#code#>
//        case .setting:
//            <#code#>
        }
    }
}
