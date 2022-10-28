//
//  SelfieCameraOptionsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 28/10/2022.
//

import UIKit
import SwifterSwift

class SelfieCameraOptionsViewController: UIViewController {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var mainView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configViews()
    }


    private func configViews() {
        mainView.roundCorners([.topLeft, .topRight], radius: 32.0)
    }
}
