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

fileprivate let kSeasonsMaxItems: Int = 3
fileprivate let kOverviewLabelMaxLines: Int = 5

class EntertainmentDetailsViewController: BaseViewController<EntertainmentDetailsViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
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
    @IBOutlet weak var seasonsTableView: IntrinsicTableView!
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

    private var btnSearch: UIButton!
    private var btnShare: UIButton!

    // MARK: - Properties
    
    private let popViewTriggerS = PublishRelay<Void>()
    private let retryTriggerS = PublishRelay<Void>()
    private let seasonSelectTriggerS = PublishRelay<Season>()
    private let personSelectTriggerS = PublishRelay<PersonModelType>()
    private let entertainmentSelectTriggerS = PublishRelay<EntertainmentModelType>()

    private let seasonsDataS = BehaviorRelay<[Season]>(value: [])
    
    private var entertainmentDetail: EntertainmentDetailModelType?

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
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            toSeasonListTrigger: seasonsSectionHeaderView.rx.seeMoreButtonTap.asDriver(),
            seasonSelectTrigger: seasonSelectTriggerS.asDriverOnErrorJustComplete(),
            personSelectTrigger: personSelectTriggerS.asDriverOnErrorJustComplete(),
            entertainmentSelectTrigger: entertainmentSelectTriggerS.asDriverOnErrorJustComplete(),
            shareTrigger: btnShare.rx.tap.asDriver(),
            retryTrigger: retryTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.entertainmentDetail
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.entertainmentDetail = item
                self.bindData(item)
                self.scrollView.isHidden = false
                self.btnShare.isEnabled = true
                self.btnShare.alpha = 1.0
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showAlert(
                    title: "error".localized,
                    message: "an_error_occurred".localized,
                    buttonTitles: ["cancel".localized, "try_again".localized]) { buttonIndex in
                        if buttonIndex == 1 {
                            self.retryTriggerS.accept(())
                        } else {
                            self.popViewTriggerS.accept(())
                        }
                    }
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
        btnSearch = UIButton(type: .system)
        btnSearch.translatesAutoresizingMaskIntoConstraints = false
        btnSearch.setImage(UIImage(named: "ic_toolbar_search"), for: .normal)
        
        btnShare = UIButton(type: .system)
        btnShare.translatesAutoresizingMaskIntoConstraints = false
        btnShare.setImage(UIImage(named: "ic_toolbar_share"), for: .normal)
        
        appToolbar.showTitleLabel = false
        appToolbar.rightButtons = [btnSearch, btnShare]
        appToolbar.rx.backButtonTap
            .bind(to: popViewTriggerS)
            .disposed(by: rx.disposeBag)
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
        overviewSectionHeaderView.showSeeMoreButton = false
        
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

        seasonsTableView.rowHeight = DimensionConstants.seasonSmallCellHeight
        seasonsTableView.separatorStyle = .none
        seasonsTableView.showsVerticalScrollIndicator = false
        seasonsTableView.isScrollEnabled = false
        seasonsTableView.register(cellWithClass: SeasonSmallCell.self)
        seasonsTableView.rx.modelSelected(Season.self)
            .bind(to: seasonSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        let seasonDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Season>> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: SeasonSmallCell.self, for: indexPath)
            cell.bind(item, offset: indexPath.row)
            cell.onPlayButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.seasonSelectTriggerS.accept(item)
            }
            return cell
        }
        
        seasonsDataS
            .asDriver()
            .map { Array($0.prefix(kSeasonsMaxItems)) }
            .map { [SectionModel(model: "", items: $0)] }
            .drive(seasonsTableView.rx.items(dataSource: seasonDataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func configureCreditsSection() {
        actorsSectionHeaderView.title = "actors".localized
        actorsSectionHeaderView.showSeeMoreButton = false
        
        let actorsCollectionViewLayout = UICollectionViewFlowLayout()
        actorsCollectionViewLayout.scrollDirection = .horizontal
        actorsCollectionView.collectionViewLayout = actorsCollectionViewLayout
        actorsCollectionView.register(cellWithClass: PersonHorizontalCell.self)
        actorsCollectionView.dataSource = self
        actorsCollectionView.delegate = self
        actorsCollectionView.showsHorizontalScrollIndicator = false
        
        lblDirector.textColor = AppColors.textColorPrimary
        lblDirector.font = AppFonts.caption1
        
        lblWriters.textColor = AppColors.textColorPrimary
        lblWriters.font = AppFonts.caption1
    }
    
    private func configureGallerySection() {
        gallerySectionHeaderView.title = "gallery".localized

    }
    
    private func configureRecommendSection() {
        recommendSectionHeaderView.title = "recommend".localized

        let recommendCollectionViewLayout = UICollectionViewFlowLayout()
        recommendCollectionViewLayout.scrollDirection = .horizontal
        recommendCollectionView.collectionViewLayout = recommendCollectionViewLayout
        recommendCollectionView.register(cellWithClass: EntertainmentHorizontalCell.self)
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        recommendCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureOthersView() {
        scrollView.isHidden = true
        loadingIndicator.startAnimating()
        btnShare.isEnabled = false
        btnShare.alpha = 0.5
    }
    
    private func bindData(_ entertainmentDetail: EntertainmentDetailModelType) {
        // Entertainment title
        lblTitle.text = entertainmentDetail.entertainmentDetailTitle

        // Entertainment poster
        ivPoster.setImage(with: entertainmentDetail.entertainmentPosterURL)
        
        // Entertainment rating
        lblRatingText.text = "rating".localized
        lblRating.text = DataUtils.getRatingText(entertainmentDetail.entertainmentVoteAverage)
        
        // Entertainment release date
        lblReleaseDateText.text = "year".localized
        if let releaseYear = DataUtils.getReleaseYear(entertainmentDetail.entertainmentReleaseDate) {
            lblReleaseDate.text = "\(releaseYear)"
        } else {
            lblReleaseDate.text = "unknown".localized
        }
        
        // Entertainment duration
        if entertainmentDetail.entertainmentModelType == .movie {
            lblDurationText.text = "duration".localized
            lblDuration.text = DataUtils.getDurationText(entertainmentDetail.entertainmentRuntime)
        } else {
            lblDurationText.text = "episodes".localized
            if let numsOfEpisodes = entertainmentDetail.entertainmentRuntime {
                lblDuration.text = "\(numsOfEpisodes)"
            } else {
                lblDuration.text = "unknown".localized
            }
        }

        // Entertainment overview
        lblOverview.text = entertainmentDetail.entertainmentOverview
        
        // Entertainment seasons
        sectionSeasonsView.isHidden = entertainmentDetail.entertainmentModelType == .movie
        seasonsDataS.accept(entertainmentDetail.entertainmentSeasons ?? [])

        // Entertainment credits
        actorsCollectionView.reloadData()

        let directorsString = entertainmentDetail.entertainmentDirectors?.map { $0.name }.joined(separator: ", ") ?? "unknown".localized
        lblDirector.text = "Director: \(directorsString)"
        lblDirector.highlight(text: directorsString, color: AppColors.textColorSecondary)
        
        let writersString = entertainmentDetail.entertainmentWriters?.map { $0.name }.joined(separator: ", ") ?? "unknown".localized
        lblWriters.text = "Writers: \(writersString)"
        lblWriters.highlight(text: writersString, color: AppColors.textColorSecondary)
                
        // Entertainment gallery
        
        // Entertainment recommend
        recommendCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension EntertainmentDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == actorsCollectionView {
            return entertainmentDetail?.entertainmentCasts.count ?? 0
        } else if collectionView == recommendCollectionView {
            return entertainmentDetail?.entertainmentRecommends.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == actorsCollectionView {
            guard let item = entertainmentDetail?.entertainmentCasts[indexPath.row] else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withClass: PersonHorizontalCell.self, for: indexPath)
            cell.bind(item)
            return cell
        } else if collectionView == recommendCollectionView {
            guard let item = entertainmentDetail?.entertainmentRecommends[indexPath.row] else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentHorizontalCell.self, for: indexPath)
            cell.bind(item)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension EntertainmentDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == actorsCollectionView {
            guard let item = entertainmentDetail?.entertainmentCasts[indexPath.row] else { return }
            personSelectTriggerS.accept(item)
        } else if collectionView == recommendCollectionView {
            guard let item = entertainmentDetail?.entertainmentRecommends[indexPath.row] else { return }
            entertainmentSelectTriggerS.accept(item)
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EntertainmentDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == actorsCollectionView {
            let itemHeight = collectionView.frame.height
            let itemWidth = itemHeight * DimensionConstants.personHorizontalCellRatio
            return .init(width: itemWidth, height: itemHeight)
        } else if collectionView == recommendCollectionView {
            let itemHeight = collectionView.frame.height
            let itemWidth = itemHeight * DimensionConstants.entertainmentHorizontalCellRatio
            return .init(width: itemWidth, height: itemHeight)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16.0, bottom: 0.0, right: 16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == actorsCollectionView {
            return DimensionConstants.personHorizontalCellSpacing
        } else if collectionView == recommendCollectionView {
            return DimensionConstants.entertainmentHorizontalCellSpacing
        } else {
            return .zero
        }
    }
}
