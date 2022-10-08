//
//  WishlistViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import UIKit
import RxCocoa
import RxSwift
import SwifterSwift

class WishlistViewController: BaseViewController<WishlistViewModel>, TabBarSelectable, Searchable {

    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    
    var btnSearch: SearchButton = SearchButton()
    
    // MARK: - Properties
        
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
     
        configureAppToolbar()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = WishlistViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
    }
}

// MARK: - Private functions

extension WishlistViewController {
    private func configureAppToolbar() {
        appToolbar.title = "wishlist".localized
        appToolbar.showBackButton = false
        appToolbar.rightButtons = [btnSearch]
    }
}

// MARK: - TabBarSelectable

extension WishlistViewController {
    func handleTabBarSelection() {
        
    }
}
