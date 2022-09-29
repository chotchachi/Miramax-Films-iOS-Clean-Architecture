//
//  GenreDetailsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift

class GenreDetailsViewController: BaseViewController<GenreDetailsViewModel>, LoadingDisplayable, ErrorRetryable, Searchable {
    
    // MARK: - PresentationMode
    
    enum PresentationMode {
        case preview
        case detail
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnTogglePresentationMode: UIButton!
    
    var btnSearch: SearchButton = SearchButton()
    var loaderView: LoadingView = LoadingView()
    var errorRetryView: ErrorRetryView = ErrorRetryView()
    
    // MARK: - Properties
    
    private var previewLayout: ColumnFlowLayout!
    private var detailLayout: ColumnFlowLayout!
    
    private var presentationMode: PresentationMode = .preview
    
    private var isAnimatingPresentation: Bool = false
    private var isFetching: Bool = false
    
    private let refreshTriggerS = PublishRelay<Void>()
    private let loadMoreTriggerS = PublishRelay<Void>()
    private let entertainmentSelectTriggerS = PublishRelay<EntertainmentModelType>()
    
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureCollectionView()
        configureHeaderView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = GenreDetailsViewModel.Input(
            popViewTrigger: appToolbar.rx.backButtonTap.asDriver(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
            refreshTrigger: refreshTriggerS.asDriverOnErrorJustComplete(),
            loadMoreTrigger: loadMoreTriggerS.asDriverOnErrorJustComplete(),
            entertainmentSelectTrigger: entertainmentSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let entertainmentDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, EntertainmentModelType>> { dataSource, collectionView, indexPath, item in
            switch self.presentationMode {
            case .preview:
                let cell = collectionView.dequeueReusableCell(withClass: EntertainmentPreviewCollectionViewCell.self, for: indexPath)
                cell.bind(item)
                return cell
            case .detail:
                let cell = collectionView.dequeueReusableCell(withClass: EntertainmentDetailCollectionViewCell.self, for: indexPath)
                cell.bind(item)
                return cell
            }
        }
        
        output.genre
            .map { $0.name }
            .drive(appToolbar.rx.title)
            .disposed(by: rx.disposeBag)
        
        output.entertainmentData
            .map { [SectionModel(model: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: entertainmentDataSource))
            .disposed(by: rx.disposeBag)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoader() : self?.hideLoader()
                self?.isFetching = isLoading
                if !isLoading {
                    self?.collectionView.refreshControl?.endRefreshing(with: 0.5)
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

extension GenreDetailsViewController {
    private func configureAppToolbar() {
        appToolbar.rightButtons = [btnSearch]
    }
    
    private func configureCollectionView() {
        previewLayout = ColumnFlowLayout(
            cellsPerRow: 2,
            ratio: DimensionConstants.entertainmentPreviewCellRatio,
            minimumInteritemSpacing: DimensionConstants.entertainmentPreviewCellSpacing,
            minimumLineSpacing: DimensionConstants.entertainmentPreviewCellSpacing,
            sectionInset: .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0),
            scrollDirection: .vertical
        )
        
        detailLayout = ColumnFlowLayout(
            cellsPerRow: 1,
            ratio: DimensionConstants.entertainmentDetailCellRatio,
            minimumInteritemSpacing: DimensionConstants.entertainmentDetailCellSpacing,
            minimumLineSpacing: DimensionConstants.entertainmentDetailCellSpacing,
            sectionInset: .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0),
            scrollDirection: .vertical
        )
        
        collectionView.collectionViewLayout = presentationMode == .preview ? previewLayout : detailLayout
        collectionView.delegate = self
        collectionView.register(cellWithClass: EntertainmentPreviewCollectionViewCell.self)
        collectionView.register(cellWithClass: EntertainmentDetailCollectionViewCell.self)
        collectionView.rx.modelSelected(EntertainmentModelType.self)
            .bind(to: entertainmentSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        collectionView.refreshControl = DefaultRefreshControl(title: "refresh".localized) { [weak self] in
            self?.refreshTriggerS.accept(())
        }
    }
    
    private func configureHeaderView() {
        btnTogglePresentationMode.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.togglePresentationMode()
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func togglePresentationMode() {
        guard !isAnimatingPresentation else { return }
        
        switch presentationMode {
        case .preview:
            presentationMode = .detail
            btnTogglePresentationMode.setImage(UIImage(named: "ic_grid_mode"), for: .normal)
            updateCollectionViewLayout(detailLayout)
        case .detail:
            presentationMode = .preview
            btnTogglePresentationMode.setImage(UIImage(named: "ic_list_mode"), for: .normal)
            updateCollectionViewLayout(previewLayout)
        }
    }
    
    private func updateCollectionViewLayout(_ layout: UICollectionViewLayout) {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        isAnimatingPresentation = true
        collectionView.setCollectionViewLayout(layout, animated: true) { completed in
            self.isAnimatingPresentation = !completed
        }
    }
}

// MARK: - UICollectionViewDelegate

extension GenreDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 && !isFetching {
            loadMoreTriggerS.accept(())
        }
    }
}
