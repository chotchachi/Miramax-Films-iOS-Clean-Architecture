//
//  AppDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 05/09/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var mainWindow = UIWindow()
    private let router = AppCoordinator().strongRouter

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appDIContainer = AppDIContainer.shared
        let remoteDataSource: RemoteDataSourceProtocol = appDIContainer.resolve()
        remoteDataSource.configure(with: "9f7ceb7615afe6f16274a953ad31c29e")
        
        if #available(iOS 13.0, *) {
            mainWindow.overrideUserInterfaceStyle = .light // force disable dark mode
        }
        
        router.setRoot(for: mainWindow)
        
        return true
    }
}
