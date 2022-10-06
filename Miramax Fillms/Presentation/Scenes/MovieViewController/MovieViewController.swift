//
//  MovieViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import Domain

fileprivate let kPreviewCollectionViewMinHeight: CGFloat = 500.0

class MovieViewController: BaseViewController<MovieViewModel>, Searchable {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// Section genres
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var genresLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var genresRetryButton: PrimaryButton!
    
    /// Section upcoming
    @IBOutlet weak var sectionUpcomingView: UIView!
    @IBOutlet weak var upcomingSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var upcomingRetryButton: PrimaryButton!
    
    /// Section selfie
    @IBOutlet weak var sectionSelfieView: UIView!
    @IBOutlet weak var selfieSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var selfieView: SelfieWithMovieView!
    
    /// Section tab layout
    @IBOutlet weak var sectionTabLayoutView: UIView!
    @IBOutlet weak var tabLayout: TabLayout!
    
    /// Section preview
    @IBOutlet weak var sectionPreviewView: UIView!
    @IBOutlet weak var previewCollectionView: SelfSizingCollectionView!
    @IBOutlet weak var previewCollectionViewHc: NSLayoutConstraint!
    @IBOutlet weak var previewLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewRetryButton: PrimaryButton!
    
    /// Section preview see more
    @IBOutlet weak var sectionPreviewSeeMoreView: UIView!
    @IBOutlet weak var previewSeeMoreButton: PrimaryButton!

    var btnSearch: SearchButton = SearchButton()

    // MARK: - Properties
    
    private let genresDataS = BehaviorRelay<[Genre]>(value: [])
    private let upcomingDataS = BehaviorRelay<[EntertainmentModelType]>(value: [])
    private let previewDataS = BehaviorRelay<[EntertainmentModelType]>(value: [])

    private let previewTabTriggerS = PublishRelay<MoviePreviewTab>()
    private let entertainmentSelectTriggerS = PublishRelay<EntertainmentModelType>()
    private let genreSelectTriggerS = PublishRelay<Genre>()

    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureSectionGenres()
        configureSectionUpcoming()
        configureSelfieView()
        configureSectionTabLayout()
        configureSectionPreview()
        configureSectionPreviewSeeMore()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = MovieViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            retryGenreTrigger: genresRetryButton.rx.tap.asDriver(),
            retryUpcomingTrigger: upcomingRetryButton.rx.tap.asDriver(),
            retryPreviewTrigger: previewRetryButton.rx.tap.asDriver(),
            selectionEntertainmentTrigger: entertainmentSelectTriggerS.asDriverOnErrorJustComplete(),
            selectionGenreTrigger: genreSelectTriggerS.asDriverOnErrorJustComplete(),
            previewTabTrigger: previewTabTriggerS.asDriverOnErrorJustComplete(),
            seeMoreUpcomingTrigger: upcomingSectionHeaderView.rx.seeMoreButtonTap.asDriver(),
            seeMorePreviewTrigger: previewSeeMoreButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.genresViewState
            .drive(onNext: { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .initial, .paging:
                    break
                case .populated(let items):
                    self.genresLoadingIndicator.stopAnimating()
                    self.genresCollectionView.isHidden = false
                    self.genresRetryButton.isHidden = true
                    self.genresDataS.accept(items)
                case .error:
                    self.genresLoadingIndicator.stopAnimating()
                    self.genresCollectionView.isHidden = true
                    self.genresRetryButton.isHidden = false
                }
            })
            .disposed(by: rx.disposeBag)
        
        output.upcomingViewState
            .drive(onNext: { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .initial, .paging:
                    break
                case .populated(let items):
                    self.upcomingLoadingIndicator.stopAnimating()
                    self.upcomingCollectionView.isHidden = false
                    self.upcomingRetryButton.isHidden = true
                    self.upcomingDataS.accept(items)
                case .error:
                    self.upcomingLoadingIndicator.stopAnimating()
                    self.upcomingCollectionView.isHidden = true
                    self.upcomingRetryButton.isHidden = false
                }
            })
            .disposed(by: rx.disposeBag)
        
        output.previewViewState
            .drive(onNext: { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .initial, .paging:
                    break
                case .populated(let items):
                    self.previewLoadingIndicator.stopAnimating()
                    self.previewCollectionView.isHidden = false
                    self.previewRetryButton.isHidden = true
                    self.sectionPreviewSeeMoreView.isHidden = false
                    self.previewDataS.accept(items)
                case .error:
                    self.previewLoadingIndicator.stopAnimating()
                    self.previewCollectionView.isHidden = true
                    self.previewRetryButton.isHidden = false
                    self.sectionPreviewSeeMoreView.isHidden = true
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let previewContentHeight = previewCollectionView.intrinsicContentSize.height
        previewCollectionViewHc.constant = previewContentHeight < kPreviewCollectionViewMinHeight ? kPreviewCollectionViewMinHeight : previewContentHeight
    }
}

// MARK: - Private functions

extension MovieViewController {
    private func configureAppToolbar() {
        appToolbar.title = "movie".localized
        appToolbar.showBackButton = false
        appToolbar.rightButtons = [btnSearch]
    }
    
    private func configureSectionGenres() {
        genresLoadingIndicator.startAnimating()
        
        genresRetryButton.titleText = "retry".localized
        genresRetryButton.isHidden = true
        genresRetryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.genresLoadingIndicator.startAnimating()
                self.genresRetryButton.isHidden = true
                self.genresCollectionView.isHidden = true
            })
            .disposed(by: rx.disposeBag)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(width: DimensionConstants.genreCellWidth, height: DimensionConstants.genreCellHeight)
        collectionViewLayout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        collectionViewLayout.minimumLineSpacing = 12.0
        genresCollectionView.collectionViewLayout = collectionViewLayout
        genresCollectionView.showsHorizontalScrollIndicator = false
        genresCollectionView.register(cellWithClass: GenreCollectionViewCell.self)
        genresCollectionView.rx.modelSelected(Genre.self)
            .bind(to: genreSelectTriggerS)
            .disposed(by: rx.disposeBag)

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Genre>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: GenreCollectionViewCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        genresDataS
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: genresCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func configureSectionUpcoming() {
        upcomingSectionHeaderView.title = "upcoming".localized

        upcomingLoadingIndicator.startAnimating()
        
        upcomingRetryButton.titleText = "retry".localized
        upcomingRetryButton.isHidden = true
        upcomingRetryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.upcomingLoadingIndicator.startAnimating()
                self.upcomingRetryButton.isHidden = true
                self.upcomingCollectionView.isHidden = true
            })
            .disposed(by: rx.disposeBag)
        
        let collectionViewLayout = ColumnFlowLayout(
            cellsPerRow: 1,
            ratio: DimensionConstants.entertainmentHorizontalCellRatio,
            minimumInteritemSpacing: 0.0,
            minimumLineSpacing: DimensionConstants.entertainmentHorizontalCellSpacing,
            sectionInset: .init(top: 0, left: 16.0, bottom: 0.0, right: 16.0),
            scrollDirection: .horizontal
        )
        upcomingCollectionView.collectionViewLayout = collectionViewLayout
        upcomingCollectionView.showsHorizontalScrollIndicator = false
        upcomingCollectionView.register(cellWithClass: EntertainmentHorizontalCell.self)
        upcomingCollectionView.rx.modelSelected(EntertainmentModelType.self)
            .bind(to: entertainmentSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, EntertainmentModelType>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentHorizontalCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        upcomingDataS
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: upcomingCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func configureSelfieView() {
        selfieSectionHeaderView.title = "selfie_with_movie".localized
        selfieSectionHeaderView.showSeeMoreButton = false
    }
    
    private func configureSectionTabLayout() {
        tabLayout.titles = MoviePreviewTab.allCases.map { $0.title }
        tabLayout.delegate = self
        tabLayout.selectionTitle(index: MoviePreviewTab.defaultTab.index ?? 1, animated: false)
    }
    
    private func configureSectionPreview() {
        previewLoadingIndicator.startAnimating()
        
        previewRetryButton.titleText = "retry".localized
        previewRetryButton.isHidden = true
        previewRetryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.previewLoadingIndicator.startAnimating()
                self.previewRetryButton.isHidden = true
                self.previewCollectionView.isHidden = true
            })
            .disposed(by: rx.disposeBag)
        
        let collectionViewLayout = ColumnFlowLayout(
            cellsPerRow: UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2,
            ratio: DimensionConstants.entertainmentPreviewCellRatio,
            minimumInteritemSpacing: DimensionConstants.entertainmentPreviewCellSpacing,
            minimumLineSpacing: DimensionConstants.entertainmentPreviewCellSpacing,
            sectionInset: .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0),
            scrollDirection: .vertical
        )
        
        previewCollectionView.collectionViewLayout = collectionViewLayout
        previewCollectionView.isScrollEnabled = false
        previewCollectionView.showsVerticalScrollIndicator = false
        previewCollectionView.register(cellWithClass: EntertainmentPreviewCollectionViewCell.self)
        previewCollectionView.rx.modelSelected(EntertainmentModelType.self)
            .bind(to: entertainmentSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, EntertainmentModelType>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentPreviewCollectionViewCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        previewDataS
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: previewCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func configureSectionPreviewSeeMore() {
        sectionPreviewSeeMoreView.isHidden = true
        
        previewSeeMoreButton.titleText = "see_more".localized
    }
}

// MARK: - TabLayoutDelegate

extension MovieViewController: TabLayoutDelegate {
    func didSelectAtIndex(_ index: Int) {
        previewLoadingIndicator.startAnimating()
        previewRetryButton.isHidden = true
        previewCollectionView.isHidden = true
        
        if let tab = MoviePreviewTab.element(index) {
            previewTabTriggerS.accept(tab)
        }
    }
}
