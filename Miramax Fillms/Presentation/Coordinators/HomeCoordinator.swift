//
//  HomeCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import XCoordinator

enum HomeTabRoute: Route {
    case movie
    case tvShow
    case geners
//    case wishlist
    case setting
}

class HomeCoordinator: TabBarCoordinator<HomeTabRoute> {
    private let movieRoute: StrongRouter<MovieRoute>
    private let tvShowRoute: StrongRouter<TVShowRoute>
    private let genresRoute: StrongRouter<GenresRoute>
    private let settingRoute: StrongRouter<SettingRoute>
    
    init(appDIContainer: AppDIContainer) {
        let movieCoordinator = MovieCoordinator(appDIContainer: appDIContainer)
        movieCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        movieRoute = movieCoordinator.strongRouter

        let tvShowCoordinator = TVShowCoordinator(appDIContainer: appDIContainer)
        tvShowCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        tvShowRoute = tvShowCoordinator.strongRouter
        
        let genresCoordinator = GenresCoordinator(appDIContainer: appDIContainer)
        genresCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        genresRoute = genresCoordinator.strongRouter
        
        let settingCoordinator = SettingCoordinator(appDIContainer: appDIContainer)
        settingCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 3)
        settingRoute = settingCoordinator.strongRouter
        
        super.init(tabs: [movieRoute, tvShowRoute, genresRoute, settingRoute], select: movieRoute)
    }
    
    override func prepareTransition(for route: HomeTabRoute) -> TabBarTransition {
        switch route {
        case .movie:
            return .select(movieRoute)
        case .tvShow:
            return .select(tvShowRoute)
        case .geners:
            return .select(genresRoute)
//        case .wishlist:
//            <#code#>
        case .setting:
            return .select(settingRoute)
        }
    }
}
