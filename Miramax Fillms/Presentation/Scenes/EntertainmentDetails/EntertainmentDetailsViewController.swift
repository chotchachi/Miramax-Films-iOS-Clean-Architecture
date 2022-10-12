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
import SnapKit
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
    @IBOutlet weak var btnBookmark: BookmarkButton!

    /// Section header
    @IBOutlet weak var sectionHeaderView: UIView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRatingText: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDurationText: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblReleaseDateText: UILabel!
    @IBOutlet weak var posterGradientView: GradientView!
    @IBOutlet weak var genresStackView: UIStackView!
    
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
    @IBOutlet weak var ivGalleryLargeThumb: UIImageView!
    @IBOutlet weak var ivGallerySmallThumb1: UIImageView!
    @IBOutlet weak var ivGallerySmallThumb2: UIImageView!
    @IBOutlet weak var ivGallerySmallThumb3: UIImageView!
    
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
    private let entertainentCastsS = BehaviorRelay<[PersonViewModel]>(value: [])
    private let entertainentRecommendationsS = BehaviorRelay<[EntertainmentViewModel]>(value: [])
    private let viewImageTriggerS = PublishRelay<(UIView, UIImage)>()

    private let seasonSelectTriggerS = PublishRelay<Season>()
    private let castSelectTriggerS = PublishRelay<PersonViewModel>()
    private let entertainmentSelectTriggerS = PublishRelay<EntertainmentViewModel>()
    
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
            castSelectTrigger: castSelectTriggerS.asDriverOnErrorJustComplete(),
            entertainmentSelectTrigger: entertainmentSelectTriggerS.asDriverOnErrorJustComplete(),
            shareTrigger: btnShare.rx.tap.asDriver(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
            seeMoreRecommendTrigger: recommendSectionHeaderView.rx.actionButtonTap.asDriver(),
            toggleBookmarkTrigger: btnBookmark.rx.tap.asDriver(),
            viewImageTrigger: viewImageTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.entertainmentViewModel
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
        
        posterGradientView.startColor = AppColors.colorAccent.withAlphaComponent(0.0)
        posterGradientView.endColor = AppColors.colorAccent
        
        genresStackView.spacing = 4.0
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
        actorsCollectionView.rx.modelSelected(PersonViewModel.self)
            .bind(to: castSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        let actorDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PersonViewModel>> { dataSource, collectionView, indexPath, item in
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
        
        [ivGalleryLargeThumb, ivGallerySmallThumb1, ivGallerySmallThumb2, ivGallerySmallThumb3].forEach { view in
            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(galleryImageViewTapped(_:))))
        }
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
        recommendCollectionView.rx.modelSelected(EntertainmentViewModel.self)
            .bind(to: entertainmentSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        let recommendDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, EntertainmentViewModel>> { dataSource, collectionView, indexPath, item in
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
    
    private func bindData(_ item: EntertainmentViewModel) {
        // Entertainment title
        lblTitle.text = item.name
        
        // Entertainment is bookmark
        btnBookmark.isBookmark = item.isBookmark

        // Entertainment poster
        ivPoster.setImage(with: item.posterURL)
        
        // Entertainment genres
        let genreButtons = item.genres?.prefix(2).map { createGenreButton(with: $0.name) } ?? []
        genresStackView.removeArrangedSubviews()
        genresStackView.addArrangedSubviews(genreButtons)
        genreButtons.forEach { view in
            view.snp.makeConstraints { make in
                make.width.equalTo(57.0)
                make.height.equalToSuperview()
            }
        }
        if let genres = item.genres, genres.count > 2 {
            let genreMoreButton = createGenreButton(with: "\(genres.count - 2)+")
            genreMoreButton.addTarget(self, action: #selector(genreMoreButtonTapped(_:)), for: .touchUpInside)
            genresStackView.addArrangedSubview(genreMoreButton)
            genreMoreButton.snp.makeConstraints { make in
                make.width.equalTo(32.0)
                make.height.equalToSuperview()
            }
        }

        // Entertainment rating
        lblRatingText.text = "rating".localized
        lblRating.text = DataUtils.getRatingText(item.rating)
        
        // Entertainment release date
        lblReleaseDateText.text = "year".localized
        if let releaseYear = DataUtils.getReleaseYear(item.releaseDate) {
            lblReleaseDate.text = "\(releaseYear)"
        } else {
            lblReleaseDate.text = "unknown".localized
        }
        
        // Entertainment duration
        if item.type == .movie {
            lblDurationText.text = "duration".localized
            lblDuration.text = DataUtils.getDurationText(item.runtime)
        } else {
            lblDurationText.text = "episodes".localized
            if let numsOfEpisodes = item.runtime {
                lblDuration.text = "\(numsOfEpisodes)"
            } else {
                lblDuration.text = "unknown".localized
            }
        }

        // Entertainment overview
        lblOverview.text = item.overview
        sectionOverviewView.isHidden = item.overview.isEmpty /// Hide section overview if overview empty
        
        // Entertainment seasons
        sectionSeasonsView.isHidden = item.type == .movie
        entertainentSeasonsS.accept(item.seasons ?? [])

        // Entertainment credits
        entertainentCastsS.accept(item.casts ?? [])
        
        let directorsString = item.directors?.map { $0.name }.joined(separator: ", ") ?? "unknown".localized
        lblDirector.text = "Director: \(directorsString)"
        lblDirector.highlight(text: directorsString, color: AppColors.textColorSecondary)
        
        let writersString = item.writers?.map { $0.name }.joined(separator: ", ") ?? "unknown".localized
        lblWriters.text = "Writers: \(writersString)"
        lblWriters.highlight(text: writersString, color: AppColors.textColorSecondary)
                
        // Entertainment gallery
        if let images = item.backdropImages {
            sectionGalleryView.isHidden = false
            [ivGalleryLargeThumb, ivGallerySmallThumb1, ivGallerySmallThumb2, ivGallerySmallThumb3].enumerated().forEach { offset, view in
                view?.setImage(with: images[safe: offset]?.fileURL)
            }
        } else {
            sectionGalleryView.isHidden = true
        }
        
        // Entertainment recommend
        let recommendations = item.recommendations ?? []
        entertainentRecommendationsS.accept(recommendations)
        sectionRecommendView.isHidden = recommendations.isEmpty /// Hide section recommend if result empty
    }
    
    private func createGenreButton(with text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColors.colorYellow
        button.cornerRadius = 8.0
        button.setTitle(text, for: .normal)
        button.setTitleColor(AppColors.colorPrimary, for: .normal)
        button.titleLabel?.font = AppFonts.caption1
        return button
    }
    
    @objc private func genreMoreButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func galleryImageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView, let image = imageView.image else { return }
        viewImageTriggerS.accept((imageView, image))
    }
}
