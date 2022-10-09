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
    
    var btnSearch: SearchButton = SearchButton()
    
    // MARK: - Properties
    
    private var currentPreviewTab: WishlistPreviewTab = .defaultTab
    private let previewTabTriggerS = PublishRelay<WishlistPreviewTab>()
    private let removeAllTriggerS = PublishRelay<Void>()
    private let wishlistItemSelectTriggerS = PublishRelay<WishlistViewItem>()

    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
     
        configureAppToolbar()
        configureHeader()
        configureCollectionView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = WishlistViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            previewTabTrigger: previewTabTriggerS.asDriverOnErrorJustComplete(),
            removeAllTrigger: removeAllTriggerS.asDriverOnErrorJustComplete(),
            wishlistItemSelectionTrigger: wishlistItemSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, WishlistViewItem>> { dataSource, collectionView, indexPath, item in
            switch item {
            case .movie(item: let item):
                let cell = collectionView.dequeueReusableCell(withClass: EntertainmentDetailCollectionViewCell.self, for: indexPath)
                cell.bind(item, showPlayTrailer: false)
                return cell
            case .tvShow(item: let item):
                let cell = collectionView.dequeueReusableCell(withClass: EntertainmentDetailCollectionViewCell.self, for: indexPath)
                cell.bind(item, showPlayTrailer: false)
                return cell
            case .actor(item: let item):
                let cell = collectionView.dequeueReusableCell(withClass: PersonDetailCollectionViewCell.self, for: indexPath)
                cell.bind(item)
                return cell
            }
        }
        
        output.wishlistViewData
            .do(onNext: { [weak self] items in
                guard let self = self else { return }
                self.updateHeaderView(with: items)
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
        collectionView.register(cellWithClass: EntertainmentDetailCollectionViewCell.self)
        collectionView.register(cellWithClass: PersonDetailCollectionViewCell.self)
        collectionView.rx.modelSelected(WishlistViewItem.self)
            .bind(to: wishlistItemSelectTriggerS)
            .disposed(by: rx.disposeBag)
    }
    
    private func updateHeaderView(with items: [WishlistViewItem]) {
        lblItemsCount.text = "\(items.count) \(currentPreviewTab.title)"
        btnRemoveAll.isHidden = items.isEmpty
    }
    
    private func presentRemoveAllAlert() {
        
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