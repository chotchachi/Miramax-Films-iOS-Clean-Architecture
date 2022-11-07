//
//  SearchViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import DeviceKit
import Domain

class SearchViewController: BaseViewController<SearchViewModel>, LoadingDisplayable {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSearchEmpty: UIView!
    @IBOutlet weak var lblEmptyMessage: UILabel!
        
    var loaderView: LoadingView = LoadingView()
    
    // MARK: - Properties
    
    private var searchViewDataItems: [SearchViewData] = []
    
    private let searchTriggerS = PublishRelay<String?>()
    private let retryTriggerS = PublishRelay<Void>()
    private let personSelectTriggerS = PublishRelay<PersonViewModel>()
    private let entertainmentSelectTriggerS = PublishRelay<EntertainmentViewModel>()
    private let clearAllSearchRecentTriggerS = PublishRelay<Void>()
    private let seeMoreMovieTriggerS = PublishRelay<Void>()
    private let seeMoreTVShowTriggerS = PublishRelay<Void>()
    private let seeMorePeopleTriggerS = PublishRelay<Void>()

    // MARK: - Lifecycle

    override func configView() {
        super.configView()
        
        hideKeyboardWhenTappedAround()
        configureAppToolbar()
        configureCollectionView()
        configureOtherViews()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SearchViewModel.Input(
            searchTrigger: searchTriggerS.asDriverOnErrorJustComplete(),
            cancelTrigger: btnCancel.rx.tap.asDriver(),
            personSelectTrigger: personSelectTriggerS.asDriverOnErrorJustComplete(),
            entertainmentSelectTrigger: entertainmentSelectTriggerS.asDriverOnErrorJustComplete(),
            clearAllSearchRecentTrigger: clearAllSearchRecentTriggerS.asDriverOnErrorJustComplete(),
            seeMoreMovieTrigger: seeMoreMovieTriggerS.asDriverOnErrorJustComplete(),
            seeMoreTVShowTrigger: seeMoreTVShowTriggerS.asDriverOnErrorJustComplete(),
            seeMorePeopleTrigger: seeMorePeopleTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.searchViewDataItems
            .drive(onNext: { [weak self] items in
                guard let self = self else { return }
                self.searchViewDataItems = items
                self.collectionView.reloadData()
                self.collectionView.isHidden = items.isEmpty
                self.viewSearchEmpty.isHidden = !items.isEmpty
                if items.isEmpty {
                    self.lblEmptyMessage.text = "\("search_result_empty".localized) “\(self.tfSearch.text ?? "")”"
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoader() : self?.hideLoader()
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Private functions

extension SearchViewController {
    private func configureAppToolbar() {
        appToolbar.title = "search".localized
        appToolbar.showBackButton = false
    }
    
    private func configureCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 32.0, left: 0.0, bottom: 32.0, right: 0.0)
        collectionView.register(cellWithClass: EntertainmentHorizontalListCollectionViewCell.self)
        collectionView.register(cellWithClass: PersonHorizontalListCell.self)
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
        
        lblEmptyMessage.font = AppFonts.caption1SemiBold
        lblEmptyMessage.textColor = AppColors.textColorPrimary
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

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text, !query.isEmpty && !query.isBlank else { return false }
        collectionView.isHidden = true
        viewSearchEmpty.isHidden = true
        searchTriggerS.accept(query)
        tfSearch.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewDataItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = searchViewDataItems[indexPath.row]
        switch item {
        case .recent(items: let items):
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentHorizontalListCollectionViewCell.self, for: indexPath)
            cell.bind(items, indexPath: indexPath, headerTitle: "recent".localized, headerActionButtonTitle: "clear".localized, showActionButton: !items.isEmpty)
            cell.delegate = self
            return cell
        case .movie(items: let items, hasNextPage: let hasNextPage):
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentHorizontalListCollectionViewCell.self, for: indexPath)
            cell.bind(items, indexPath: indexPath, headerTitle: "movies".localized, headerActionButtonTitle: "see_more".localized, showActionButton: hasNextPage)
            cell.delegate = self
            return cell
        case .tvShow(items: let items, hasNextPage: let hasNextPage):
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentHorizontalListCollectionViewCell.self, for: indexPath)
            cell.bind(items, indexPath: indexPath, headerTitle: "tvshows".localized, headerActionButtonTitle: "see_more".localized, showActionButton: hasNextPage)
            cell.delegate = self
            return cell
        case .actor(items: let items, hasNextPage: let hasNextPage):
            let cell = collectionView.dequeueReusableCell(withClass: PersonHorizontalListCell.self, for: indexPath)
            cell.bind(items, indexPath: indexPath, headerTitle: "actors".localized, headerActionButtonTitle: "see_more".localized, showActionButton: hasNextPage)
            cell.delegate = self
            return cell
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemHeight: CGFloat!
        let item = searchViewDataItems[indexPath.row]
        switch item {
        case .actor:
            itemHeight = Device.current.isPad ? 300.0 : 150.0
        default:
            itemHeight = Device.current.isPad ? 400.0 : 200.0
        }
        let itemWidth = collectionView.frame.width
        return .init(width: itemWidth, height: itemHeight)
    }
}

// MARK: - EntertainmentHorizontalListCollectionViewCellDelegate

extension SearchViewController: EntertainmentHorizontalListCollectionViewCellDelegate {
    func entertainmentHorizontalList(onItemTapped item: EntertainmentViewModel) {
        entertainmentSelectTriggerS.accept(item)
    }
    
    func entertainmentHorizontalList(onActionButtonTapped indexPath: IndexPath) {
        let item = searchViewDataItems[indexPath.row]
        switch item {
        case .recent:
            clearAllSearchRecentTriggerS.accept(())
        case .movie:
            seeMoreMovieTriggerS.accept(())
        case .tvShow:
            seeMoreTVShowTriggerS.accept(())
        case .actor:
            break
        }
    }
    
    func entertainmentHorizontalList(onRetryButtonTapped indexPath: IndexPath) {
        
    }
}

// MARK: - PersonHorizontalListCellDelegate

extension SearchViewController: PersonHorizontalListCellDelegate {
    func personHorizontalList(onItemTapped item: PersonViewModel) {
        personSelectTriggerS.accept(item)
    }
    
    func personHorizontalList(onActionButtonTapped indexPath: IndexPath) {
        seeMorePeopleTriggerS.accept(())
    }
    
    func personHorizontalList(onRetryButtonTapped indexPath: IndexPath) {
        
    }
}
