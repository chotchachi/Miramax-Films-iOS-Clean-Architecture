//
//  AppDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 05/09/2022.
//

import UIKit
import XCoordinator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var mainWindow = UIWindow()
    
    private let appDIContainer = AppDIContainer.shared
    private var router: StrongRouter<AppRoute>!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            mainWindow.overrideUserInterfaceStyle = .light // force disable dark mode
        }
        
        router = AppCoordinator(appDIContainer: appDIContainer).strongRouter
        router.setRoot(for: mainWindow)
        
        return true
    }
}
