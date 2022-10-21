//
//  SelfieMovieViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/10/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Domain
import SwifterSwift

fileprivate let kFrameCellPerRow: Int = 2

class SelfieMovieViewController: BaseViewController<SelfieMovieViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    
    @IBOutlet weak var recentlySectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentlyHeaderView: SectionHeaderView!
    @IBOutlet weak var recentlyCollectionView: UICollectionView!
    
    @IBOutlet weak var tabLayout: TabLayout!
    @IBOutlet weak var frameCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    private var selfieFrameData: [SelfieFrame] = []
    
    private let selfieTabTriggerS = PublishRelay<SelfieMovieTab>()
    private let selfieFrameSelectTriggerS = PublishRelay<SelfieFrame>()
    
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureSectionRecently()
        configureTabLayout()
        configureFrameCollectionView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SelfieMovieViewModel.Input(
            popViewTrigger: appToolbar.rx.backButtonTap.asDriver(),
            selfieFrameSelectTrigger: selfieFrameSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let frameDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, SelfieFrame>> { datasource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: SelfieFramePreviewCollectionViewCell.self, for: indexPath)
            cell.bind(item)
            cell.onApplyButtonTapped = { [weak self] in
                self?.selfieFrameSelectTriggerS.accept(item)
            }
            return cell
        }
        
        output.selfieFrameData
            .do(onNext: { [weak self] items in
                self?.selfieFrameData = items
            })
            .map { [SectionModel(model: "", items: $0)] }
            .drive(frameCollectionView.rx.items(dataSource: frameDataSource))
            .disposed(by: rx.disposeBag)
        
        let recentlyFrameDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, SelfieFrame>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: SelfieFrameThumbCollectionViewCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        output.recentlyFrameData
            .map { [SectionModel(model: "", items: $0)] }
            .drive(recentlyCollectionView.rx.items(dataSource: recentlyFrameDataSource))
            .disposed(by: rx.disposeBag)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        frameCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Private functions

extension SelfieMovieViewController {
    private func configureAppToolbar() {
        appToolbar.title = "selfie_movie".localized
        appToolbar.showBackButton = true
    }
    
    private func configureSectionRecently() {
        recentlyHeaderView.title = "recenlty".localized
        recentlyHeaderView.showActionButton = false
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        recentlyCollectionView.collectionViewLayout = collectionViewLayout
        recentlyCollectionView.register(cellWithClass: SelfieFrameThumbCollectionViewCell.self)
        recentlyCollectionView.delegate = self
        recentlyCollectionView.showsHorizontalScrollIndicator = false
        recentlyCollectionView.rx.modelSelected(SelfieFrame.self)
            .bind(to: selfieFrameSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        recentlySectionHeightConstraint.constant = DimensionConstants.recentlySelfieFrameHeightConstraint
    }
    
    private func configureTabLayout() {
        tabLayout.titles = SelfieMovieTab.allCases.map { $0.title }
        tabLayout.scrollStyle = .scrollable
        tabLayout.delegate = self
        tabLayout.selectionTitle(index: SelfieMovieTab.defaultTab.index ?? 1, animated: false)
    }
    
    private func configureFrameCollectionView() {
        let collectionViewLayout = CollectionViewWaterfallLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)
        collectionViewLayout.minimumColumnSpacing = 16.0
        collectionViewLayout.minimumInteritemSpacing = 16.0
        collectionViewLayout.delegate = self
        frameCollectionView.collectionViewLayout = collectionViewLayout
        frameCollectionView.register(cellWithClass: SelfieFramePreviewCollectionViewCell.self)
        frameCollectionView.rx.modelSelected(SelfieFrame.self)
            .bind(to: selfieFrameSelectTriggerS)
            .disposed(by: rx.disposeBag)
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

// MARK: - CollectionViewWaterfallLayoutDelegate

extension SelfieMovieViewController: CollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: CollectionViewWaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let image = try? UIImage(url: selfieFrameData[indexPath.row].previewURL),
              let collectionViewLayout = collectionView.collectionViewLayout as? CollectionViewWaterfallLayout else { return .zero }
        
        let imageRatio = image.size.height / image.size.width
        
        let marginsAndInsets = collectionViewLayout.sectionInset.left
        + collectionViewLayout.sectionInset.right
        + CGFloat(collectionViewLayout.minimumColumnSpacing) * CGFloat(kFrameCellPerRow - 1)
        
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(kFrameCellPerRow)).rounded(.down)
        let itemHeight = itemWidth * imageRatio
        + 38.0 // apply button height with padding top
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelfieMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height
        let itemWidth = itemHeight * DimensionConstants.selfieFrameThumbCellRatio
        return .init(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16.0, bottom: 0.0, right: 16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DimensionConstants.selfieFrameThumbCellSpacing
    }
}
