//
//  SelfieMovieViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/10/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SelfieMovieViewController: BaseViewController<SelfieMovieViewModel> {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    
    @IBOutlet weak var viewRecently: UIView!
    @IBOutlet weak var recentCollectionView: UICollectionView!

    @IBOutlet weak var tabLayout: TabLayout!
    @IBOutlet weak var frameCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    private let selfieTabTriggerS = PublishRelay<SelfieMovieTab>()

    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureTabLayout()
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SelfieMovieViewModel.Input(dismissTrigger: appToolbar.rx.backButtonTap.asDriver())
        let output = viewModel.transform(input: input)
    }
}

// MARK: - Private functions

extension SelfieMovieViewController {
    private func configureAppToolbar() {
        appToolbar.title = "selfie_movie".localized
        appToolbar.showBackButton = true
    }
    
    private func configureTabLayout() {
        tabLayout.titles = SelfieMovieTab.allCases.map { $0.title }
        tabLayout.scrollStyle = .scrollable
        tabLayout.delegate = self
        tabLayout.selectionTitle(index: SelfieMovieTab.defaultTab.index ?? 1, animated: false)
    }
}

// MARK: - TabLayoutDelegate

extension SelfieMovieViewController: TabLayoutDelegate {
    func didSelectAtIndex(_ index: Int) {
        if let tab = SelfieMovieTab.element(index) {
            selfieTabTriggerS.accept(tab)
        }
    }
}
