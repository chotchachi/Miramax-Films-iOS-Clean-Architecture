//
//  ChooseMovieViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/10/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift

class ChooseMovieViewController: BaseViewController<ChooseMovieViewModel>, LoadingDisplayable {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var loaderView: LoadingView = LoadingView()

    // MARK: - Properties

    private let searchTriggerS = PublishRelay<String?>()

    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
        
        configureCollectionView()
        configureOtherViews()
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        let input = ChooseMovieViewModel.Input(
            dismissTrigger: btnCancel.rx.tap.asDriver(),
            searchTrigger: searchTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        
    }
}

// MARK: - Private functions

extension ChooseMovieViewController {
    private func configureCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.contentInset = .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        collectionView.register(cellWithClass: EntertainmentHorizontalCell.self)
    }
    
    private func configureOtherViews() {
        btnCancel.setTitle("cancel".localized, for: .normal)
        btnCancel.setTitleColor(AppColors.colorAccent, for: .normal)
        btnCancel.titleLabel?.font = AppFonts.caption1
        
        tfSearch.delegate = self
        tfSearch.returnKeyType = .search
        tfSearch.clearButtonMode = .never
        tfSearch.textColor = AppColors.textColorPrimary
        tfSearch.attributedPlaceholder = NSAttributedString(
            string: "search_bar_placeholder".localized,
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.textColorPrimary.withAlphaComponent(0.5)]
        )
        tfSearch.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        
        btnClearSearch.isHidden = true
        btnClearSearch.addTarget(self, action: #selector(clearSearchButtonTapped(_:)), for: .touchUpInside)
        
//        lblEmptyMessage.font = AppFonts.caption1SemiBold
//        lblEmptyMessage.textColor = AppColors.textColorPrimary
    }
    
    @objc private func clearSearchButtonTapped(_ sender: UIButton) {
        tfSearch.text = ""
        tfSearch.resignFirstResponder()
        searchTriggerS.accept(nil)
    }
    
    @objc private func searchTextFieldDidChange(_ sender: UITextField) {
        btnClearSearch.isHidden = sender.text?.isEmpty ?? true
    }
}

// MARK: - UITextFieldDelegate

extension ChooseMovieViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text, !query.isEmpty && !query.isBlank else { return false }
        collectionView.isHidden = true
//        viewSearchEmpty.isHidden = true
        searchTriggerS.accept(query)
        tfSearch.resignFirstResponder()
        return true
    }
}
