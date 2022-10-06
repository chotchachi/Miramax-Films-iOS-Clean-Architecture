//
//  TVShowViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import Domain

fileprivate let kUpcomingMaxItems: Int = 6
fileprivate let kUpcomingTableViewMinHeight: CGFloat = 200.0
fileprivate let kPreviewCollectionViewMinHeight: CGFloat = 500.0

class TVShowViewController: BaseViewController<TVShowViewModel>, Searchable {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// Section genres
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var genresLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var genresRetryButton: PrimaryButton!
    
    /// Section banner
    @IBOutlet weak var sectionBannerView: UIView!
    @IBOutlet weak var bannerMainView: UIView!
    @IBOutlet weak var bannerBackdropImageView: UIImageView!
    @IBOutlet weak var bannerPosterImageView: UIImageView!
    @IBOutlet weak var bannerPosterWrapView: UIView!
    @IBOutlet weak var bannerNameLabel: UILabel!
    @IBOutlet weak var bannerDescriptionLabel: UILabel!
    @IBOutlet weak var bannerLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerRetryButton: PrimaryButton!
    
    /// Section upcoming
    @IBOutlet weak var sectionUpcomingView: UIView!
    @IBOutlet weak var upcomingSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var upcomingTableView: SelfSizingTableView!
    @IBOutlet weak var upcomingTableViewHc: NSLayoutConstraint!
    @IBOutlet weak var upcomingViewAllButton: PrimaryButton!
    @IBOutlet weak var upcomingLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var upcomingRetryButton: PrimaryButton!
    
    /// Section tab layout
    @IBOutlet weak var sectionTabLayoutView: UIView!
    @IBOutlet weak var tabLayout: TabLayout!
    
    /// Section preview
    @IBOutlet weak var sectionPreviewView: UIView!
    @IBOutlet weak var previewCollectionView: SelfSizingCollectionView!
    @IBOutlet weak var previewCollectionViewHc: NSLayoutConstraint!
    @IBOutlet weak var previewLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewRetryButton: PrimaryButton!
    
    var btnSearch: SearchButton = SearchButton()

    // MARK: - Properties
    
    private let genresDataS = BehaviorRelay<[Genre]>(value: [])
    private let upcomingDataS = BehaviorRelay<[EntertainmentModelType]>(value: [])
    private let previewDataS = BehaviorRelay<[EntertainmentModelType]>(value: [])

    private let previewTabTriggerS = PublishRelay<TVShowPreviewTab>()
    private let entertainmentSelectTriggerS = PublishRelay<EntertainmentModelType>()
    private let genreSelectTriggerS = PublishRelay<Genre>()
    
    private var bannerEntertertainmentItem: EntertainmentModelType?
    
    // MARK: - Lifecycle

    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureSectionGenres()
        configureSectionBanner()
        configureSectionUpcoming()
        configureSectionTabLayout()
        configureSectionPreview()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = TVShowViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            retryGenreTrigger: genresRetryButton.rx.tap.asDriver(),
            retryBannerTrigger: bannerRetryButton.rx.tap.asDriver(),
            retryUpcomingTrigger: upcomingRetryButton.rx.tap.asDriver(),
            retryPreviewTrigger: previewRetryButton.rx.tap.asDriver(),
            selectionEntertainmentTrigger: entertainmentSelectTriggerS.asDriverOnErrorJustComplete(),
            selectionGenreTrigger: genreSelectTriggerS.asDriverOnErrorJustComplete(),
            previewTabTrigger: previewTabTriggerS.asDriverOnErrorJustComplete(),
            seeMoreUpcomingTrigger: upcomingViewAllButton.rx.tap.asDriver()
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
        
        output.bannerViewState
            .drive(onNext: { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .initial, .paging:
                    break
                case .populated(let items):
                    self.bannerLoadingIndicator.stopAnimating()
                    self.bannerMainView.isHidden = false
                    self.bannerRetryButton.isHidden = true
                    if let firstItem = items.first {
                        self.bannerEntertertainmentItem = firstItem
                        self.bannerPosterImageView.setImage(with: firstItem.entertainmentModelPosterURL)
                        self.bannerBackdropImageView.setImage(with: firstItem.entertainmentModelBackdropURL)
                        self.bannerNameLabel.text = firstItem.entertainmentModelName
                        self.bannerDescriptionLabel.text = firstItem.entertainmentModelOverview
                    }
                case .error:
                    self.bannerLoadingIndicator.stopAnimating()
                    self.bannerMainView.isHidden = true
                    self.bannerRetryButton.isHidden = false
                    break
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
                    self.upcomingTableView.isHidden = false
                    self.upcomingRetryButton.isHidden = true
                    self.upcomingDataS.accept(items)
                case .error:
                    self.upcomingLoadingIndicator.stopAnimating()
                    self.upcomingTableView.isHidden = true
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
                    self.previewDataS.accept(items)
                case .error:
                    self.previewLoadingIndicator.stopAnimating()
                    self.previewCollectionView.isHidden = true
                    self.previewRetryButton.isHidden = false
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let previewContentHeight = previewCollectionView.intrinsicContentSize.height
        previewCollectionViewHc.constant = previewContentHeight < kPreviewCollectionViewMinHeight ? kPreviewCollectionViewMinHeight : previewContentHeight
        
        let upcomingContentHeight = upcomingTableView.intrinsicContentSize.height
        upcomingTableViewHc.constant = upcomingContentHeight < kUpcomingTableViewMinHeight ? kUpcomingTableViewMinHeight : upcomingContentHeight
    }
}

// MARK: - Private functions

extension TVShowViewController {
    private func configureAppToolbar() {
        appToolbar.title = "tvshow".localized
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
    
    private func configureSectionBanner() {
        bannerMainView.isUserInteractionEnabled = true
        bannerMainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBannerMainViewTapped(_:))))
        
        bannerPosterImageView.cornerRadius = 8.0
                
        bannerNameLabel.font = AppFonts.subheadSemiBold
        bannerNameLabel.textColor = AppColors.textColorPrimary
        
        bannerDescriptionLabel.font = AppFonts.caption1
        bannerDescriptionLabel.textColor = AppColors.textColorPrimary
        
        bannerPosterWrapView.cornerRadius = 8.0
        bannerPosterWrapView.borderColor = AppColors.colorAccent
        bannerPosterWrapView.borderWidth = 1.0
        bannerPosterWrapView.shadowColor = UIColor.black.withAlphaComponent(0.2)
        bannerPosterWrapView.shadowOffset = .init(width: 0.0, height: 2.0)
        bannerPosterWrapView.shadowRadius = 10.0
        bannerPosterWrapView.shadowOpacity = 1.0
        bannerPosterWrapView.layer.masksToBounds = false
        
        bannerLoadingIndicator.startAnimating()
        
        bannerRetryButton.titleText = "retry".localized
        bannerRetryButton.isHidden = true
        bannerRetryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.bannerLoadingIndicator.startAnimating()
                self.bannerRetryButton.isHidden = true
                self.bannerMainView.isHidden = true
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func configureSectionUpcoming() {
        upcomingSectionHeaderView.title = "upcoming".localized
        upcomingSectionHeaderView.showSeeMoreButton = false

        upcomingViewAllButton.titleText = "view_all".localized
        
        upcomingLoadingIndicator.startAnimating()
        
        upcomingRetryButton.titleText = "retry".localized
        upcomingRetryButton.isHidden = true
        upcomingRetryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.upcomingLoadingIndicator.startAnimating()
                self.upcomingRetryButton.isHidden = true
                self.upcomingTableView.isHidden = true
            })
            .disposed(by: rx.disposeBag)


        upcomingTableView.separatorStyle = .none
        upcomingTableView.register(cellWithClass: EntertainmentRankTableViewCell.self)
        upcomingTableView.rx.modelSelected(EntertainmentModelType.self)
            .bind(to: entertainmentSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, EntertainmentModelType>> { datasource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: EntertainmentRankTableViewCell.self, for: indexPath)
            cell.bind(item, offset: indexPath.row)
            cell.onPlayButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.entertainmentSelectTriggerS.accept(item)
            }
            return cell
        }

        upcomingDataS
            .map { Array($0.prefix(kUpcomingMaxItems)) }
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: upcomingTableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func configureSectionTabLayout() {
        tabLayout.titles = TVShowPreviewTab.allCases.map { $0.title }
        tabLayout.delegate = self
        tabLayout.selectionTitle(index: TVShowPreviewTab.defaultTab.index ?? 1, animated: false)
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
    
    @objc private func onBannerMainViewTapped(_ sender: UITapGestureRecognizer) {
        guard let item = bannerEntertertainmentItem else { return }
        entertainmentSelectTriggerS.accept(item)
    }
}

// MARK: - TabLayoutDelegate

extension TVShowViewController: TabLayoutDelegate {
    func didSelectAtIndex(_ index: Int) {
        previewLoadingIndicator.startAnimating()
        previewRetryButton.isHidden = true
        previewCollectionView.isHidden = true
        switch index {
        case 0:
            previewTabTriggerS.accept(.topRating)
        case 1:
            previewTabTriggerS.accept(.news)
        case 2:
            previewTabTriggerS.accept(.trending)
        default:
            break
        }
    }
}
