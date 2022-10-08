//
//  PersonBiographyViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import TagListView
import Domain

class PersonBiographyViewController: BaseViewController<PersonBiographyViewModel>, Searchable, Shareable {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var departmentTagListView: TagListView!
    
    @IBOutlet weak var lblBiography: UILabel!

    var btnSearch: SearchButton = SearchButton()
    var btnShare: ShareButton = ShareButton()
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureOthersView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = PersonBiographyViewModel.Input(
            popViewTrigger: appToolbar.rx.backButtonTap.asDriver(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            shareTrigger: btnShare.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.person
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.bindData(item)
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Private functions

extension PersonBiographyViewController {
    private func configureAppToolbar() {
        appToolbar.showTitleLabel = false
        appToolbar.rightButtons = [btnSearch, btnShare]
    }
    
    private func configureOthersView() {
        lblTitle.textColor = AppColors.textColorPrimary
        lblTitle.font = AppFonts.headlineSemiBold
        
        departmentTagListView.tagBackgroundColor = AppColors.colorYellow
        departmentTagListView.textColor = AppColors.colorPrimary
        departmentTagListView.textFont = AppFonts.caption2
        
        lblBiography.textColor = AppColors.textColorPrimary
        lblBiography.font = AppFonts.caption1
    }
    
    private func bindData(_ person: Person) {
        lblTitle.text = person.name
        
        departmentTagListView.removeAllTags()
        departmentTagListView.addTags(person.departments ?? [])
        
        lblBiography.text = person.biography
    }
}
