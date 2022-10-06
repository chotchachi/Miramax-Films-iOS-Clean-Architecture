//
//  SettingViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 06/10/2022.
//

import UIKit
import RxCocoa
import RxSwift
import SwifterSwift

class SettingViewController: BaseViewController<SettingViewModel>, Searchable {

    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    
    @IBOutlet weak var viewPolicy: UIView!
    @IBOutlet weak var lblPolicy: UILabel!

    @IBOutlet weak var viewFeedback: UIView!
    @IBOutlet weak var lblFeedback: UILabel!

    @IBOutlet weak var viewShareApp: UIView!
    @IBOutlet weak var lblShareApp: UILabel!

    var btnSearch: SearchButton = SearchButton()
    
    // MARK: - Properties
        
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
     
        configureAppToolbar()
        configureOtherView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SettingViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
    }
}

// MARK: - Private functions

extension SettingViewController {
    private func configureAppToolbar() {
        appToolbar.title = "setting".localized
        appToolbar.showBackButton = false
        appToolbar.rightButtons = [btnSearch]
    }
    
    private func configureOtherView() {
        [viewPolicy, viewFeedback, viewShareApp].forEach { view in
            view?.backgroundColor = UIColor(hex: 0x1A2138)
            view?.cornerRadius = 16.0
            view?.borderColor = UIColor(hex: 0x354271)
            view?.borderWidth = 1.0
            view?.shadowOffset = .init(width: 0.0, height: 1.0)
            view?.shadowRadius = 5.0
            view?.shadowOpacity = 0.4
            view?.shadowColor = .white.withAlphaComponent(0.4)
            view?.clipsToBounds = false
            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionViewTapped(_:))))
        }
        
        lblPolicy.font = AppFonts.bodySemiBold
        lblPolicy.text = "policy".localized
        
        lblFeedback.font = AppFonts.bodySemiBold
        lblFeedback.text = "feedback".localized

        lblShareApp.font = AppFonts.bodySemiBold
        lblShareApp.text = "share_app".localized
    }
    
    @objc private func actionViewTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        if view == viewPolicy {
            print("policy")
        } else if view == viewFeedback {
            print("feedback")
        } else if view == viewShareApp {
            print("share")
        }
    }
}
