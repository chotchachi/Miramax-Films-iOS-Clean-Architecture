//
//  MovieDetailsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import UIKit
import RxCocoa
import RxSwift

class MovieDetailsViewController: BaseViewController<MovieDetailsViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    
    private var btnSearch: UIButton!
    private var btnShare: UIButton!

    // MARK: - Properties
    
    private var popViewTriggerS = PublishRelay<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func configView() {
        super.configView()
        
        btnSearch = UIButton(type: .system)
        btnSearch.translatesAutoresizingMaskIntoConstraints = false
        btnSearch.setImage(UIImage(named: "ic_toolbar_search"), for: .normal)
        
        btnShare = UIButton(type: .system)
        btnShare.translatesAutoresizingMaskIntoConstraints = false
        btnShare.setImage(UIImage(named: "ic_toolbar_share"), for: .normal)
        
        appToolbar.delegate = self
        appToolbar.rightButtons = [btnSearch, btnShare]
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = MovieDetailsViewModel.Input(
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            shareTrigger: btnShare.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output
    }

}

// MARK: - AppToolbarDelegate

extension MovieDetailsViewController: AppToolbarDelegate {
    func appToolbar(onBackButtonTapped button: UIButton) {
        popViewTriggerS.accept(())
    }
}
