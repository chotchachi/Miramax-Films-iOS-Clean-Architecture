//
//  EntertainmentDetailsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SwifterSwift
import Domain

fileprivate let kSeasonsMaxItems: Int = 3
fileprivate let kOverviewLabelMaxLines: Int = 5

class EntertainmentDetailsViewController: BaseViewController<EntertainmentDetailsViewModel>, LoadingDisplayable, ErrorRetryable, Searchable, Shareable {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// Section title
    @IBOutlet weak var sectionTitleView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    /// Section header
    @IBOutlet weak var sectionHeaderView: UIView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRatingText: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDurationText: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblReleaseDateText: UILabel!

    /// Section overview
    @IBOutlet weak var sectionOverviewView: UIView!
    @IBOutlet weak var overviewSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var btnSeeMoreOverview: UIButton!
    
    /// Section seasons
    @IBOutlet weak var sectionSeasonsView: UIView!
    @IBOutlet weak var seasonsSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var seasonsTableView: SelfSizingTableView!
    @IBOutlet weak var seasonsTableViewHc: NSLayoutConstraint!
    
    /// Section credits
    @IBOutlet weak var sectionCreditsView: UIView!
    @IBOutlet weak var actorsSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var lblWriters: UILabel!
    
    /// Section gallery
    @IBOutlet weak var sectionGalleryView: UIView!
    @IBOutlet weak var gallerySectionHeaderView: SectionHeaderView!

    /// Section recommend
    @IBOutlet weak var sectionRecommendView: UIView!
    @IBOutlet weak var recommendSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    var btnSearch: SearchButton = SearchButton()
    var btnShare: ShareButton = ShareButton()
    var loaderView: LoadingView = LoadingView()
    var errorRetryView: ErrorRetryView = ErrorRetryView()

    // MARK: - Properties
    
    private let entertainentSeasonsS = BehaviorRelay<[Season]>(value: [])
    private let entertainentCastsS = BehaviorRelay<[PersonModelType]>(value: [])
    private let entertainentRecommendationsS = BehaviorRelay<[EntertainmentModelType]>(value: [])

    private let seasonSelectTriggerS = PublishRelay<Season>()
    private let personSelectTriggerS = PublishRelay<PersonModelType>()
    private let entertainmentSelectTriggerS = PublishRelay<EntertainmentModelType>()
    
    private var lblOverviewShowMore = false
    
    // MARK: - Lifecycle

    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureTitleSection()
        configureHeaderSection()
        configureOverviewSection()
        configureSeasonsSection()
        configureCreditsSection()
        configureGallerySection()
        configureRecommendSection()
        configureOthersView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = EntertainmentDetailsViewModel.Input(
            popViewTrigger: appToolbar.rx.backButtonTap.asDriver(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            toSeasonListTrigger: seasonsSectionHeaderView.rx.actionButtonTap.asDriver(),
            seasonSelectTrigger: seasonSelectTriggerS.asDriverOnErrorJustComplete(),
            personSelectTrigger: personSelectTriggerS.asDriverOnErrorJustComplete(),
            entertainmentSelectTrigger: entertainmentSelectTriggerS.asDriverOnErrorJustComplete(),
            shareTrigger: btnShare.rx.tap.asDriver(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
            seeMoreRecommendTrigger: recommendSectionHeaderView.rx.actionButtonTap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.entertainment
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.bindData(item)
                self.scrollView.isHidden = false
                self.enableShare()
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoader() : self?.hideLoader()
                if isLoading {
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
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        seasonsTableViewHc.constant = seasonsTableView.intrinsicContentSize.height
    }
}

// MARK: - Private functions

extension EntertainmentDetailsViewController {
    private func configureAppToolbar() {
        appToolbar.showTitleLabel = false
        appToolbar.rightButtons = [btnSearch, btnShare]
    }
    
    private func configureTitleSection() {
        lblTitle.textColor = AppColors.textColorPrimary
        lblTitle.font = AppFonts.headlineSemiBold
    }
    
    private func configureHeaderSection() {
        lblRating.textColor = AppColors.textColorPrimary
        lblRating.font = AppFonts.subheadBold
        
        lblRatingText.textColor = AppColors.textColorSecondary
        lblRatingText.font = AppFonts.caption2
        
        lblDuration.textColor = AppColors.textColorPrimary
        lblDuration.font = AppFonts.subheadBold
        
        lblDurationText.textColor = AppColors.textColorSecondary
        lblDurationText.font = AppFonts.caption2
        
        lblReleaseDate.textColor = AppColors.textColorPrimary
        lblReleaseDate.font = AppFonts.subheadBold
        
        lblReleaseDateText.textColor = AppColors.textColorSecondary
        lblReleaseDateText.font = AppFonts.caption2
    }
    
    private func configureOverviewSection() {
        overviewSectionHeaderView.title = "overview".localized
        overviewSectionHeaderView.showActionButton = false
        
        lblOverview.textColor = AppColors.textColorSecondary
        lblOverview.font = AppFonts.caption1
        lblOverview.numberOfLines = kOverviewLabelMaxLines
        
        btnSeeMoreOverview.setTitle("see_more".localized, for: .normal)
        btnSeeMoreOverview.titleLabel?.font = AppFonts.caption1
        btnSeeMoreOverview.setTitleColor(AppColors.colorAccent, for: .normal)
        btnSeeMoreOverview.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                UIView.transition(with: self.lblOverview, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    self.lblOverviewShowMore
                    ? (self.lblOverview.numberOfLines = kOverviewLabelMaxLines)
                    : (self.lblOverview.numberOfLines = 0)
                    self.btnSeeMoreOverview.setTitle(self.lblOverviewShowMore ? "see_more".localized : "see_less".localized, for: .normal)
                }) { _ in
                    self.lblOverviewShowMore.toggle()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func configureSeasonsSection() {
        seasonsSectionHeaderView.title = "seasons".localized
        seasonsSectionHeaderView.actionButtonTittle = "see_more".localized

        seasonsTableView.rowHeight = DimensionConstants.seasonSmallCellHeight
        seasonsTableView.separatorStyle = .none
        seasonsTableView.showsVerticalScrollIndicator = false
        seasonsTableView.isScrollEnabled = false
        seasonsTableView.register(cellWithClass: SeasonSmallTableViewCell.self)
        seasonsTableView.rx.modelSelected(Season.self)
            .bind(to: seasonSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        let seasonDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Season>> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: SeasonSmallTableViewCell.self, for: indexPath)
            cell.bind(item, offset: indexPath.row)
            cell.onPlayButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.seasonSelectTriggerS.accept(item)
            }
            return cell
        }
        
        entertainentSeasonsS
            .map { Array($0.prefix(kSeasonsMaxItems)) }
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: seasonsTableView.rx.items(dataSource: seasonDataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func configureCreditsSection() {
        actorsSectionHeaderView.title = "actors".localized
        actorsSectionHeaderView.showActionButton = false
        
        let collectionViewLayout = ColumnFlowLayout(
            cellsPerRow: 1,
            ratio: DimensionConstants.personHorizontalCellRatio,
            minimumInteritemSpacing: 0.0,
            minimumLineSpacing: DimensionConstants.personHorizontalCellSpacing,
            sectionInset: .init(top: 0, left: 16.0, bottom: 0.0, right: 16.0),
            scrollDirection: .horizontal
        )
        actorsCollectionView.collectionViewLayout = collectionViewLayout
        actorsCollectionView.register(cellWithClass: PersonHorizontalCell.self)
        actorsCollectionView.showsHorizontalScrollIndicator = false
        actorsCollectionView.rx.modelSelected(PersonModelType.self)
            .bind(to: personSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        let actorDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PersonModelType>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: PersonHorizontalCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        entertainentCastsS
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: actorsCollectionView.rx.items(dataSource: actorDataSource))
            .disposed(by: rx.disposeBag)
        
        lblDirector.textColor = AppColors.textColorPrimary
        lblDirector.font = AppFonts.caption1
        
        lblWriters.textColor = AppColors.textColorPrimary
        lblWriters.font = AppFonts.caption1
    }
    
    private func configureGallerySection() {
        gallerySectionHeaderView.title = "gallery".localized
        gallerySectionHeaderView.actionButtonTittle = "see_more".localized
    }
    
    private func configureRecommendSection() {
        recommendSectionHeaderView.title = "recommend".localized
        recommendSectionHeaderView.actionButtonTittle = "see_more".localized
        
        let collectionViewLayout = ColumnFlowLayout(
            cellsPerRow: 1,
            ratio: DimensionConstants.entertainmentHorizontalCellRatio,
            minimumInteritemSpacing: 0.0,
            minimumLineSpacing: DimensionConstants.entertainmentHorizontalCellSpacing,
            sectionInset: .init(top: 0, left: 16.0, bottom: 0.0, right: 16.0),
            scrollDirection: .horizontal
        )
        recommendCollectionView.collectionViewLayout = collectionViewLayout
        recommendCollectionView.register(cellWithClass: EntertainmentHorizontalCell.self)
        recommendCollectionView.showsHorizontalScrollIndicator = false
        recommendCollectionView.rx.modelSelected(EntertainmentModelType.self)
            .bind(to: entertainmentSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        let recommendDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, EntertainmentModelType>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentHorizontalCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        entertainentRecommendationsS
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: recommendCollectionView.rx.items(dataSource: recommendDataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func configureOthersView() {
        scrollView.isHidden = true
        disableShare()
    }
    
    private func bindData(_ item: EntertainmentModelType) {
        // Entertainment title
        lblTitle.text = item.entertainmentModelName

        // Entertainment poster
        ivPoster.setImage(with: item.entertainmentModelPosterURL)
        
        // Entertainment rating
        lblRatingText.text = "rating".localized
        lblRating.text = DataUtils.getRatingText(item.entertainmentModelRating)
        
        // Entertainment release date
        lblReleaseDateText.text = "year".localized
        if let releaseYear = DataUtils.getReleaseYear(item.entertainmentModelReleaseDate) {
            lblReleaseDate.text = "\(releaseYear)"
        } else {
            lblReleaseDate.text = "unknown".localized
        }
        
        // Entertainment duration
        if item.entertainmentModelType == .movie {
            lblDurationText.text = "duration".localized
            lblDuration.text = DataUtils.getDurationText(item.entertainmentModelRuntime)
        } else {
            lblDurationText.text = "episodes".localized
            if let numsOfEpisodes = item.entertainmentModelRuntime {
                lblDuration.text = "\(numsOfEpisodes)"
            } else {
                lblDuration.text = "unknown".localized
            }
        }

        // Entertainment overview
        lblOverview.text = item.entertainmentModelOverview
        
        // Entertainment seasons
        sectionSeasonsView.isHidden = item.entertainmentModelType == .movie
        entertainentSeasonsS.accept(item.entertainmentModelSeasons ?? [])

        // Entertainment credits
        entertainentCastsS.accept(item.entertainmentModelCasts ?? [])
        
        let directorsString = item.entertainmentModelDirectors?.map { $0.name }.joined(separator: ", ") ?? "unknown".localized
        lblDirector.text = "Director: \(directorsString)"
        lblDirector.highlight(text: directorsString, color: AppColors.textColorSecondary)
        
        let writersString = item.entertainmentModelWriters?.map { $0.name }.joined(separator: ", ") ?? "unknown".localized
        lblWriters.text = "Writers: \(writersString)"
        lblWriters.highlight(text: writersString, color: AppColors.textColorSecondary)
                
        // Entertainment gallery
        
        
        // Entertainemtn recommend
        entertainentRecommendationsS.accept(item.entertainmentModelRecommends ?? [])
    }
}
