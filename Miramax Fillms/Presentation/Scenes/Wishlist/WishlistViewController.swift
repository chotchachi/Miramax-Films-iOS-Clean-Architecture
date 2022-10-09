//
//  WishlistViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SwifterSwift

class WishlistViewController: BaseViewController<WishlistViewModel>, TabBarSelectable, Searchable {
    
    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tabLayout: TabLayout!
    @IBOutlet weak var lblItemsCount: UILabel!
    @IBOutlet weak var lblItemsCountDes: UILabel!
    @IBOutlet weak var btnRemoveAll: UIButton!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    
    var btnSearch: SearchButton = SearchButton()
    
    // MARK: - Properties
    
    private var currentPreviewTab: WishlistPreviewTab = .defaultTab
    private let previewTabTriggerS = PublishRelay<WishlistPreviewTab>()
    private let removeAllTriggerS = PublishRelay<Void>()
    private let removeItemTriggerS = PublishRelay<WishlistViewItem>()
    private let wishlistItemSelectTriggerS = PublishRelay<WishlistViewItem>()
    
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureHeader()
        configureCollectionView()
        configureEmptyView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = WishlistViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            previewTabTrigger: previewTabTriggerS.asDriverOnErrorJustComplete(),
            removeAllTrigger: removeAllTriggerS.asDriverOnErrorJustComplete(),
            removeItemTrigger: removeItemTriggerS.asDriverOnErrorJustComplete(),
            wishlistItemSelectionTrigger: wishlistItemSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, WishlistViewItem>> { dataSource, collectionView, indexPath, viewItem in
            switch viewItem {
            case .movie(item: let item):
                let cell = collectionView.dequeueReusableCell(withClass: EntertainmentWishlistCollectionViewCell.self, for: indexPath)
                cell.bind(item)
                cell.onDeleteButtonTapped = { [weak self] in
                    self?.presentRemoveItemAlert(with: viewItem)
                }
                return cell
            case .tvShow(item: let item):
                let cell = collectionView.dequeueReusableCell(withClass: EntertainmentWishlistCollectionViewCell.self, for: indexPath)
                cell.bind(item)
                cell.onDeleteButtonTapped = { [weak self] in
                    self?.presentRemoveItemAlert(with: viewItem)
                }
                return cell
            case .actor(item: let item):
                let cell = collectionView.dequeueReusableCell(withClass: PersonWishlistCollectionViewCell.self, for: indexPath)
                cell.bind(item)
                cell.onDeleteButtonTapped = { [weak self] in
                    self?.presentRemoveItemAlert(with: viewItem)
                }
                return cell
            }
        }
        
        output.wishlistViewData
            .do(onNext: { [weak self] items in
                guard let self = self else { return }
                self.updateHeaderView(with: items)
                self.emptyView.isHidden = !items.isEmpty
            })
            .map { [SectionModel(model: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Private functions

extension WishlistViewController {
    private func configureAppToolbar() {
        appToolbar.title = "wishlist".localized
        appToolbar.showBackButton = false
        appToolbar.rightButtons = [btnSearch]
    }
    
    private func configureHeader() {
        tabLayout.titles = WishlistPreviewTab.allCases.map { $0.title }
        tabLayout.delegate = self
        tabLayout.selectionTitle(index: WishlistPreviewTab.defaultTab.index ?? 1, animated: false)
        
        lblItemsCount.font = AppFonts.caption1
        lblItemsCount.textColor = AppColors.textColorPrimary
        
        lblItemsCountDes.font = AppFonts.caption2
        lblItemsCountDes.textColor = AppColors.textColorSecondary
        lblItemsCountDes.text = "added_to_wishlist".localized
        
        btnRemoveAll.setTitle("remove_all".localized, for: .normal)
        btnRemoveAll.tintColor = AppColors.colorAccent
        btnRemoveAll.setTitleColor(AppColors.colorAccent, for: .normal)
        btnRemoveAll.setTitleColor(AppColors.colorAccent.withAlphaComponent(0.5), for: .highlighted)
        btnRemoveAll.titleLabel?.font = AppFonts.caption1
        btnRemoveAll.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.presentRemoveAllAlert()
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func configureCollectionView() {
        let layout = ColumnFlowLayout(
            cellsPerRow: 1,
            ratio: DimensionConstants.entertainmentDetailCellRatio,
            minimumInteritemSpacing: DimensionConstants.entertainmentDetailCellSpacing,
            minimumLineSpacing: DimensionConstants.entertainmentDetailCellSpacing,
            sectionInset: .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0),
            scrollDirection: .vertical
        )
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.register(cellWithClass: EntertainmentWishlistCollectionViewCell.self)
        collectionView.register(cellWithClass: PersonWishlistCollectionViewCell.self)
        collectionView.rx.modelSelected(WishlistViewItem.self)
            .bind(to: wishlistItemSelectTriggerS)
            .disposed(by: rx.disposeBag)
    }
    
    private func configureEmptyView() {
        lblEmpty.textColor = AppColors.textColorPrimary
        lblEmpty.font = AppFonts.caption1SemiBold
        lblEmpty.text = "wishlist_result_empty".localized
    }
    
    private func updateHeaderView(with items: [WishlistViewItem]) {
        lblItemsCount.text = "\(items.count) \(currentPreviewTab.title)"
        btnRemoveAll.isHidden = items.isEmpty
    }
    
    private func presentRemoveAllAlert() {
        let alertVC = PMAlertController(title: "remove_all_wishlist_alert_title".localized, description: "remove_all_wishlist_alert_message".localized)
        alertVC.gravityDismissAnimation = false
        alertVC.dismissWithBackgroudTouch = true
        alertVC.addAction(PMAlertAction(title: "remove".localized, style: .default, action: {
            self.removeAllTriggerS.accept(())
        }))
        alertVC.addAction(PMAlertAction(title: "cancel".localized, style: .cancel))
        present(alertVC, animated: true)
    }
    
    private func presentRemoveItemAlert(with item: WishlistViewItem) {
        let alertVC = PMAlertController(title: "remove_item_wishlist_alert_title".localized, description: "remove_item_wishlist_alert_message".localized)
        alertVC.gravityDismissAnimation = false
        alertVC.dismissWithBackgroudTouch = true
        alertVC.addAction(PMAlertAction(title: "remove".localized, style: .default, action: {
            self.removeItemTriggerS.accept(item)
        }))
        alertVC.addAction(PMAlertAction(title: "cancel".localized, style: .cancel))
        present(alertVC, animated: true)
    }
}

// MARK: - TabBarSelectable

extension WishlistViewController {
    func handleTabBarSelection() {
        
    }
}

// MARK: - TabLayoutDelegate

extension WishlistViewController: TabLayoutDelegate {
    func didSelectAtIndex(_ index: Int) {
        if let tab = WishlistPreviewTab.element(index) {
            currentPreviewTab = tab
            previewTabTriggerS.accept(tab)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension WishlistViewController: UICollectionViewDelegate {
    
}
