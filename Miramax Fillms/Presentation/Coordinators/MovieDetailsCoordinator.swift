//
//  MovieDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import XCoordinator

enum MovieDetailRoute: Route {
    case initial(movie: Movie)
    case pop
}

class MovieDetailsCoordinator: NavigationCoordinator<MovieDetailRoute> {
    
    private let appDIContainer: AppDIContainer
    private let movie: Movie
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, movie: Movie) {
        self.appDIContainer = appDIContainer
        self.movie = movie
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(movie: movie))
    }
    
    override func prepareTransition(for route: MovieDetailRoute) -> NavigationTransition {
        switch route {
        case .initial(movie: let movie):
            let vc = MovieDetailsViewController()
            vc.viewModel = MovieDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, movie: movie)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        }
    }
}
