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
import Kingfisher
import SwifterSwift

fileprivate let kSeasonsMaxItems: Int = 3

class EntertainmentDetailsViewController: BaseViewController<EntertainmentDetailsViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var ivPoster: UIImageView!
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRatingText: UILabel!
    
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDurationText: UILabel!

    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblReleaseDateText: UILabel!

    @IBOutlet weak var overviewSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var lblOverview: UILabel!
    
    @IBOutlet weak var seasonsSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var seasonsTableView: IntrinsicTableView!
    @IBOutlet weak var seasonsTableViewHc: NSLayoutConstraint!
    
    @IBOutlet weak var actorsSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var lblWriters: UILabel!
    
    @IBOutlet weak var gallerySectionHeaderView: SectionHeaderView!

    @IBOutlet weak var recommendSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!

    private var btnSearch: UIButton!
    private var btnShare: UIButton!

    // MARK: - Properties
    
    private let popViewTriggerS = PublishRelay<Void>()
    private let retryTriggerS = PublishRelay<Void>()
    private let seasonSelectTriggerS = PublishRelay<Season>()

    private let seasonsDataS = BehaviorRelay<[Season]>(value: [])
    
    private var entertainmentDetail: EntertainmentDetailModelType?

    override func configView() {
        super.configView()
                
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
                
        ivPoster.kf.indicatorType = .activity
        
        overviewSectionHeaderView.title = "overview".localized
        overviewSectionHeaderView.showSeeMoreButton = false
        
        seasonsSectionHeaderView.title = "seasons".localized
        
        actorsSectionHeaderView.title = "actors".localized
        actorsSectionHeaderView.showSeeMoreButton = false
        
        gallerySectionHeaderView.title = "gallery".localized
        
        recommendSectionHeaderView.title = "recommend".localized
        
        configureSeasonsTableView()
        configureActorsCollectionView()
        configureRecommendCollectionView()
        initialViewState()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = EntertainmentDetailsViewModel.Input(
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            toSeasonListTrigger: seasonsSectionHeaderView.rx.seeMoreButtonTap.asDriver(),
            seasonSelectTrigger: seasonSelectTriggerS.asDriverOnErrorJustComplete(),
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
    private func configureSeasonsTableView() {
        seasonsTableView.delegate = self
        seasonsTableView.separatorStyle = .none
        seasonsTableView.showsVerticalScrollIndicator = false
        seasonsTableView.isScrollEnabled = false
        seasonsTableView.register(cellWithClass: SeasonSmallCell.self)
        
        let seasonDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Season>> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: SeasonSmallCell.self)
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
    
    private func configureActorsCollectionView() {
        let actorsCollectionViewLayout = UICollectionViewFlowLayout()
        actorsCollectionViewLayout.scrollDirection = .horizontal
        actorsCollectionView.collectionViewLayout = actorsCollectionViewLayout
        actorsCollectionView.register(cellWithClass: PersonHorizontalCell.self)
        actorsCollectionView.dataSource = self
        actorsCollectionView.delegate = self
        actorsCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureRecommendCollectionView() {
        let recommendCollectionViewLayout = UICollectionViewFlowLayout()
        recommendCollectionViewLayout.scrollDirection = .horizontal
        recommendCollectionView.collectionViewLayout = recommendCollectionViewLayout
        recommendCollectionView.register(cellWithClass: MovieHorizontalCell.self)
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        recommendCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func bindData(_ entertainmentDetail: EntertainmentDetailModelType) {
        if let posterURL = entertainmentDetail.entertainmentPosterURL {
            ivPoster.kf.setImage(with: posterURL)
        }
        
        lblTitle.text = entertainmentDetail.entertainmentDetailTitle
        
        lblRatingText.text = "rating".localized
        lblRating.text = DataUtils.getRatingText(entertainmentDetail.entertainmentVoteAverage)
        
        lblReleaseDateText.text = "year".localized
        if let releaseYear = DataUtils.getReleaseYear(entertainmentDetail.entertainmentReleaseDate) {
            lblReleaseDate.text = "\(releaseYear)"
        } else {
            lblReleaseDate.text = "unknown".localized
        }
        
        if entertainmentDetail is MovieDetail {
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

        lblOverview.text = entertainmentDetail.entertainmentOverview
        
        let directorsString = entertainmentDetail.entertainmentDirectors.map { $0.name }.joined(separator: ", ")
        lblDirector.text = "Director: \(directorsString)"
        lblDirector.highlight(text: directorsString, color: .white.withAlphaComponent(0.5))
        
        let writersString = entertainmentDetail.entertainmentWriters.map { $0.name }.joined(separator: ", ")
        lblWriters.text = "Writers: \(writersString)"
        lblWriters.highlight(text: writersString, color: .white.withAlphaComponent(0.5))
        
        actorsCollectionView.reloadData()
        recommendCollectionView.reloadData()
        
        seasonsDataS.accept(entertainmentDetail.entertainmentSeasons ?? [])
    }

    private func initialViewState() {
        scrollView.isHidden = true
        loadingIndicator.startAnimating()
        btnShare.isEnabled = false
        btnShare.alpha = 0.5
    }
}

// MARK: - UITableViewDelegate

extension EntertainmentDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DimensionConstants.seasonSmallCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = entertainmentDetail?.entertainmentSeasons?[indexPath.row] else { return }
        seasonSelectTriggerS.accept(item)
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
            let cell = collectionView.dequeueReusableCell(withClass: MovieHorizontalCell.self, for: indexPath)
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

        } else if collectionView == recommendCollectionView {
            guard let item = entertainmentDetail?.entertainmentRecommends[indexPath.row] else { return }

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
