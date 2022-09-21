//
//  EntertainmentDetailsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import SwifterSwift

class EntertainmentDetailsViewController: BaseViewController<EntertainmentDetailsViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var ivPoster: UIImageView!
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    @IBOutlet weak var overviewSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var lblOverview: UILabel!
    
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
    
    private var popViewTriggerS = PublishRelay<Void>()
    
    private var entertainmentDetail: EntertainmentDetailModelType?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func configView() {
        super.configView()
        
        btnSearch = UIButton(type: .system)
        btnSearch.translatesAutoresizingMaskIntoConstraints = false
        btnSearch.setImage(UIImage(named: "ic_toolbar_search"), for: .normal)
        
        btnShare = UIButton(type: .system)
        btnShare.translatesAutoresizingMaskIntoConstraints = false
        btnShare.setImage(UIImage(named: "ic_toolbar_share"), for: .normal)
        
        appToolbar.delegate = self
        appToolbar.rightButtons = [btnSearch, btnShare]
        
        scrollView.isHidden = true
        loadingIndicator.startAnimating()
        
        ivPoster.kf.indicatorType = .activity
        
        let actorsCollectionViewLayout = UICollectionViewFlowLayout()
        actorsCollectionViewLayout.scrollDirection = .horizontal
        actorsCollectionView.collectionViewLayout = actorsCollectionViewLayout
        actorsCollectionView.register(cellWithClass: PersonHorizontalCell.self)
        actorsCollectionView.dataSource = self
        actorsCollectionView.delegate = self
        actorsCollectionView.showsHorizontalScrollIndicator = false
        
        let recommendCollectionViewLayout = UICollectionViewFlowLayout()
        recommendCollectionViewLayout.scrollDirection = .horizontal
        recommendCollectionView.collectionViewLayout = recommendCollectionViewLayout
        recommendCollectionView.register(cellWithClass: MovieHorizontalCell.self)
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        recommendCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = EntertainmentDetailsViewModel.Input(
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            shareTrigger: btnShare.rx.tap.asDriver(),
            retryTrigger: Driver.empty()
        )
        let output = viewModel.transform(input: input)
        
        output.entertainmentDetail
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.entertainmentDetail = item
                self.bindData(item)
                self.scrollView.isHidden = false
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func bindData(_ entertainmentDetail: EntertainmentDetailModelType) {
        lblTitle.text = entertainmentDetail.entertainmentDetailTitle
        lblRating.text = DataUtils.getRatingText(entertainmentDetail.entertainmentVoteAverage)
        lblDuration.text = DataUtils.getDurationText(entertainmentDetail.entertainmentRuntime)
        lblReleaseDate.text = DataUtils.getReleaseYear(entertainmentDetail.entertainmentReleaseDate)
        lblOverview.text = entertainmentDetail.entertainmentOverview
        
        actorsCollectionView.reloadData()
        recommendCollectionView.reloadData()
        
        let directorsString = entertainmentDetail.entertainmentDirectors.map { $0.name }.joined(separator: ", ")
        lblDirector.text = "Director: \(directorsString)"
        lblDirector.highlight(text: directorsString, color: .white.withAlphaComponent(0.5))
        
        let writersString = entertainmentDetail.entertainmentWriters.map { $0.name }.joined(separator: ", ")
        lblWriters.text = "Writers: \(writersString)"
        lblWriters.highlight(text: writersString, color: .white.withAlphaComponent(0.5))
        
        if let posterURL = entertainmentDetail.entertainmentPosterURL {
            ivPoster.kf.setImage(with: posterURL)
        }
    }

}

// MARK: - AppToolbarDelegate

extension EntertainmentDetailsViewController: AppToolbarDelegate {
    func appToolbar(onBackButtonTapped button: UIButton) {
        popViewTriggerS.accept(())
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
