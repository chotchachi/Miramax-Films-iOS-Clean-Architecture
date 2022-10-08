//
//  SplashViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import UIKit

class SplashViewController: BaseViewController<SplashViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.goToHome()
        }
    }
}
