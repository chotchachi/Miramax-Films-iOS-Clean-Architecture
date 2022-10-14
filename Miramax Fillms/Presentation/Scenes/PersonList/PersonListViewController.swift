//
//  PersonListViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 14/10/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import SnapKit
import Domain

class PersonListViewController: BaseViewController<PersonListViewModel>, LoadingDisplayable, ErrorRetryable, Searchable {

    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var collectionView: UICollectionView!

    var btnSearch: SearchButton = SearchButton()
    var loaderView: LoadingView = LoadingView()
    var errorRetryView: ErrorRetryView = ErrorRetryView()
    
    // MARK: - Properties
    
    private var previewLayout: ColumnFlowLayout!
    private var detailLayout: ColumnFlowLayout!
    
    private var isAnimatingPresentation: Bool = false
    private var isFetching: Bool = false
    
    private var isShowingSortPopup: Bool = false
    private var sortPopupView: SortPopupView?
    
    private let refreshTriggerS = PublishRelay<Void>()
    private let loadMoreTriggerS = PublishRelay<Void>()
    private let personSelectTriggerS = PublishRelay<PersonViewModel>()
    
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureCollectionView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = PersonListViewModel.Input(
            popViewTrigger: appToolbar.rx.backButtonTap.asDriver(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
            refreshTrigger: refreshTriggerS.asDriverOnErrorJustComplete(),
            loadMoreTrigger: loadMoreTriggerS.asDriverOnErrorJustComplete(),
            personSelectTrigger: personSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let entertainmentDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PersonViewModel>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: PersonWishlistCollectionViewCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        output.viewResult
//            .do(onNext: { viewResult in
//                if viewResult.isRefresh {
//                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
//                        self.collectionView.safeScrollToItem(at: .init(item: 0, section: 0), at: .top, animated: false)
//                    }
//                }
//            })
            .map { [SectionModel(model: "", items: $0.data)] }
            .drive(collectionView.rx.items(dataSource: entertainmentDataSource))
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

extension PersonListViewController {
    private func configureAppToolbar() {
        appToolbar.title = "search".localized
        appToolbar.rightButtons = [btnSearch]
    }
    
    private func configureCollectionView() {
        let collectionViewLayout = ColumnFlowLayout(
            cellsPerRow: 1,
            ratio: DimensionConstants.entertainmentDetailCellRatio,
            minimumInteritemSpacing: DimensionConstants.entertainmentDetailCellSpacing,
            minimumLineSpacing: DimensionConstants.entertainmentDetailCellSpacing,
            sectionInset: .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0),
            scrollDirection: .vertical
        )
        
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.delegate = self
        collectionView.register(cellWithClass: PersonWishlistCollectionViewCell.self)
        collectionView.rx.modelSelected(PersonViewModel.self)
            .bind(to: personSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        collectionView.refreshControl = DefaultRefreshControl(title: "refresh".localized) { [weak self] in
            self?.refreshTriggerS.accept(())
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PersonListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 && !isFetching {
            loadMoreTriggerS.accept(())
        }
    }
}
