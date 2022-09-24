//
//  PersonDetailsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift

class PersonDetailsViewController: BaseViewController<PersonDetailsViewModel> {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var btnSearch: UIButton!
    private var btnShare: UIButton!
    
    // MARK: - Properties
    
    private let popViewTriggerS = PublishRelay<Void>()
    private let retryTriggerS = PublishRelay<Void>()
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = PersonDetailsViewModel.Input(
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            retryTrigger: retryTriggerS.asDriverOnErrorJustComplete(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            shareTrigger: btnShare.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showAlert(
                    title: "error".localized,
                    message: "an_error_occurred".localized,
                    buttonTitles: ["cancel".localized, "try_again".localized]) { buttonIndex in
                        if buttonIndex == 1 {
                            self.retryTriggerS.accept(())
                        } else {
                            self.popViewTriggerS.accept(())
                        }
                    }
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Private functions

extension PersonDetailsViewController {
    private func configureAppToolbar() {
        btnSearch = UIButton(type: .system)
        btnSearch.translatesAutoresizingMaskIntoConstraints = false
        btnSearch.setImage(UIImage(named: "ic_toolbar_search"), for: .normal)
        
        btnShare = UIButton(type: .system)
        btnShare.translatesAutoresizingMaskIntoConstraints = false
        btnShare.setImage(UIImage(named: "ic_toolbar_share"), for: .normal)
        
        appToolbar.showTitleLabel = false
        appToolbar.rightButtons = [btnSearch, btnShare]
        appToolbar.rx.backButtonTap
            .bind(to: popViewTriggerS)
            .disposed(by: rx.disposeBag)
    }
    
    
}
