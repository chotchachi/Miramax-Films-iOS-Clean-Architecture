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
    
    @IBOutlet weak var viewSearchEmpty: UIView!
    @IBOutlet weak var lblEmptyMessage: UILabel!
    
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
        
        let doneTriggerWithSelectedItem = btnDone.rx.tap
            .withLatestFrom(collectionView.rx.modelSelected(EntertainmentViewModel.self))
            .asDriverOnErrorJustComplete()
        
        let input = ChooseMovieViewModel.Input(
            popViewTrigger: btnCancel.rx.tap.asDriver(),
            searchTrigger: searchTriggerS.asDriverOnErrorJustComplete(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
            refreshTrigger: refreshTriggerS.asDriverOnErrorJustComplete(),
            loadMoreTrigger: loadMoreTriggerS.asDriverOnErrorJustComplete(),
            doneTrigger: doneTriggerWithSelectedItem
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, EntertainmentViewModel>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentHorizontalCell.self, for: indexPath)
            cell.bind(item, canSelection: true)
            return cell
        }
        
        output.searchResult
            .do(onNext: { [weak self] result in
                guard let self = self else { return }
                let items = result.data
                self.collectionView.isHidden = items.isEmpty
                self.viewSearchEmpty.isHidden = !items.isEmpty
                if items.isEmpty {
                    self.lblSearchResult.isHidden = true
                    self.lblEmptyMessage.text = "\("search_result_empty".localized) “\(self.tfSearch.text ?? "")”"
                } else {
                    self.lblSearchResult.isHidden = false
                    self.lblSearchResult.text = "\("search_result_found".localized) “\(self.tfSearch.text ?? "")”"
                }
            })
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
        collectionView.rx.modelSelected(EntertainmentViewModel.self)
            .map { _ in true }
            .bind(to: btnDone.rx.isEnabled)
            .disposed(by: rx.disposeBag)
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
        
        btnDone.setTitleColor(AppColors.colorAccent, for: .normal)
        btnDone.setTitleColor(AppColors.colorAccent.withAlphaComponent(0.5), for: .disabled)
        btnDone.titleLabel?.font = AppFonts.caption1
        btnDone.isEnabled = false
        
        lblEmptyMessage.font = AppFonts.caption1SemiBold
        lblEmptyMessage.textColor = AppColors.textColorPrimary
        
        viewSearchEmpty.isHidden = true
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
        collectionView.isHidden = true
        viewSearchEmpty.isHidden = true
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
