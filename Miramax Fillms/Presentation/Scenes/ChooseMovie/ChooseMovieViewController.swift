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
import DeviceKit

class ChooseMovieViewController: BaseViewController<ChooseMovieViewModel>, LoadingDisplayable, ErrorRetryable {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblSearchResult: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    var loaderView: LoadingView = LoadingView()
    var errorRetryView: ErrorRetryView = ErrorRetryView()

    // MARK: - Properties

    private let searchTriggerS = PublishRelay<String?>()
    private let refreshTriggerS = PublishRelay<Void>()
    private let loadMoreTriggerS = PublishRelay<Void>()
    
    private var isFetching: Bool = false

    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
        
        hideKeyboardWhenTappedAround()
        configureCollectionView()
        configureOtherViews()
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        let input = ChooseMovieViewModel.Input(
            popViewTrigger: btnCancel.rx.tap.asDriver(),
            searchTrigger: searchTriggerS.asDriverOnErrorJustComplete(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
            refreshTrigger: refreshTriggerS.asDriverOnErrorJustComplete(),
            loadMoreTrigger: loadMoreTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, EntertainmentViewModel>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentHorizontalCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        output.searchResult
            .map { [SectionModel(model: "", items: $0.data)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoader() : self?.hideLoader()
                self?.isFetching = isLoading
                if !isLoading {
                    self?.collectionView.refreshControl?.endRefreshing(with: 0.5)
                } else {
                    self?.hideErrorRetryView()
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] _ in
                self?.presentErrorRetryView()
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Private functions

extension ChooseMovieViewController {
    private func configureCollectionView() {
        let collectionViewLayout = ColumnFlowLayout(
            cellsPerRow: Device.current.isPad ? 5 : 3,
            ratio: 1.5,
            minimumInteritemSpacing: 4.0,
            minimumLineSpacing: 4.0,
            sectionInset: .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0),
            scrollDirection: .vertical)
        collectionViewLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.delegate = self
        collectionView.register(cellWithClass: EntertainmentHorizontalCell.self)
        
        collectionView.refreshControl = DefaultRefreshControl(title: "refresh".localized) { [weak self] in
            self?.refreshTriggerS.accept(())
        }
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
            string: "search_selfie_movie_placeholder".localized,
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.textColorPrimary.withAlphaComponent(0.5)]
        )
        tfSearch.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        
        btnClearSearch.isHidden = true
        btnClearSearch.addTarget(self, action: #selector(clearSearchButtonTapped(_:)), for: .touchUpInside)
        
        lblSearchResult.isHidden = true
        btnDone.isEnabled = false
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
        searchTriggerS.accept(query)
        tfSearch.resignFirstResponder()
        lblSearchResult.isHidden = false
        lblSearchResult.text = "\("search_result_found".localized) “\(query)“"
        return true
    }
}

// MARK: - UICollectionViewDelegate

extension ChooseMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 && !isFetching {
            loadMoreTriggerS.accept(())
        }
    }
}
