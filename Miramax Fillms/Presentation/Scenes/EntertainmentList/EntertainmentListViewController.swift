//
//  EntertainmentListViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import SnapKit
import Domain

enum PresentationMode: String, Codable {
    case preview
    case detail
}

class EntertainmentListViewController: BaseViewController<EntertainmentListViewModel>, LoadingDisplayable, ErrorRetryable, Searchable {
    
    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnTogglePresentationMode: UIButton!
    @IBOutlet weak var btnOptions: UIButton!

    var btnSearch: SearchButton = SearchButton()
    var loaderView: LoadingView = LoadingView()
    var errorRetryView: ErrorRetryView = ErrorRetryView()
    
    // MARK: - Properties
    
    private var previewLayout: ColumnFlowLayout!
    private var detailLayout: ColumnFlowLayout!
    
    private var presentationMode: PresentationMode {
        get {
            Defaults.shared.get(for: .presentationModel) ?? .preview
        }
        set {
            Defaults.shared.set(newValue, for: .presentationModel)
            updateButtonTogglePresentationModeIcon(newValue)
        }
    }
    
    private var isAnimatingPresentation: Bool = false
    private var isFetching: Bool = false
    
    private var isShowingSortPopup: Bool = false
    private var sortPopupView: SortPopupView?
    
    private let refreshTriggerS = PublishRelay<Void>()
    private let loadMoreTriggerS = PublishRelay<Void>()
    private let sortOptionTriggerS = PublishRelay<SortOption>()
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
        
        let input = EntertainmentListViewModel.Input(
            popViewTrigger: appToolbar.rx.backButtonTap.asDriver(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
            refreshTrigger: refreshTriggerS.asDriverOnErrorJustComplete(),
            loadMoreTrigger: loadMoreTriggerS.asDriverOnErrorJustComplete(),
            sortOptionTrigger: sortOptionTriggerS.asDriverOnErrorJustComplete(),
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
                cell.bind(item, showPlayTrailer: true)
                return cell
            }
        }
        
        output.responseRoute
            .drive(onNext: { [weak self] route in
                guard let self = self else { return }
                switch route {
                case .discover(genre: let genre):
                    self.appToolbar.title = genre.name
                    self.btnOptions.isHidden = false
                case .recommendations:
                    self.appToolbar.title = "recommend".localized
                    self.btnOptions.isHidden = true
                case .movieUpcoming, .showUpcoming:
                    self.appToolbar.title = "upcoming".localized
                    self.btnOptions.isHidden = true
                case .movieTopRating, .showTopRating:
                    self.appToolbar.title = "top_rating".localized
                    self.btnOptions.isHidden = true
                case .movieNews, .showNews:
                    self.appToolbar.title = "news".localized
                    self.btnOptions.isHidden = true
                case .movieTrending, .showTrending:
                    self.appToolbar.title = "trending".localized
                    self.btnOptions.isHidden = true
                case .search:
                    self.appToolbar.title = "search".localized
                    self.btnOptions.isHidden = true
                }
            })
            .disposed(by: rx.disposeBag)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let location = touches.first?.location(in: view), let sortPopupView = sortPopupView else { return }
        if !sortPopupView.frame.contains(location) {
            dismissSortPopupView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissSortPopupView()
    }
}

// MARK: - Private functions

extension EntertainmentListViewController {
    private func configureAppToolbar() {
        appToolbar.rightButtons = [btnSearch]
    }
    
    private func configureCollectionView() {
        previewLayout = ColumnFlowLayout(
            cellsPerRow: UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2,
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
        updateButtonTogglePresentationModeIcon(presentationMode)
        
        btnTogglePresentationMode.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.togglePresentationMode()
            })
            .disposed(by: rx.disposeBag)
        
        btnOptions.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.toggleSortPopupView()
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func togglePresentationMode() {
        guard !isAnimatingPresentation else { return }
        
        switch presentationMode {
        case .preview:
            presentationMode = .detail
            updateCollectionViewLayout(detailLayout)
        case .detail:
            presentationMode = .preview
            updateCollectionViewLayout(previewLayout)
        }
    }
    
    private func updateButtonTogglePresentationModeIcon(_ mode: PresentationMode) {
        let icon = mode == .preview ? UIImage(named: "ic_list_mode") : UIImage(named: "ic_grid_mode")
        btnTogglePresentationMode.setImage(icon, for: .normal)
    }
    
    private func updateCollectionViewLayout(_ layout: UICollectionViewLayout) {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        isAnimatingPresentation = true
        collectionView.setCollectionViewLayout(layout, animated: true) { completed in
            self.isAnimatingPresentation = !completed
        }
    }
    
    private func toggleSortPopupView() {
        if !isShowingSortPopup {
            sortPopupView = SortPopupView()
            sortPopupView!.delegate = self
            sortPopupView!.setSortOptions(viewModel.sortOptions, selectedOption: viewModel.currentSortOption)
            showSortPopupView()
        } else {
            dismissSortPopupView()
        }
    }
    
    private func showSortPopupView() {
        guard !isShowingSortPopup else { return }

        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(self.sortPopupView!)
            self.sortPopupView!.snp.makeConstraints { make in
                make.top.equalTo(self.btnOptions.snp.bottom).offset(12.0)
                make.trailing.equalTo(self.btnOptions.snp.trailing)
                make.width.equalTo(151)
            }
        })
        
        btnOptions.tintColor = AppColors.colorAccent
        isShowingSortPopup = true
    }
    
    private func dismissSortPopupView() {
        guard isShowingSortPopup else { return }
        
        UIView.transition(with: self.view, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.sortPopupView?.removeFromSuperview()
        }, completion: { _ in
            self.sortPopupView = nil
        })
        
        btnOptions.tintColor = .white
        isShowingSortPopup = false
    }
}

// MARK: - UICollectionViewDelegate

extension EntertainmentListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 && !isFetching {
            loadMoreTriggerS.accept(())
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissSortPopupView()
    }
}

// MARK: - SortPopupViewDelegate

extension EntertainmentListViewController: SortPopupViewDelegate {
    func sortPopupView(onSortOptionSelect sortOption: SortOption) {
        dismissSortPopupView()
        sortOptionTriggerS.accept(sortOption)
    }
}
