//
//  PersonDetailsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import Kingfisher
import TagListView

class PersonDetailsViewController: BaseViewController<PersonDetailsViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var departmentTagListView: TagListView!
    
    @IBOutlet weak var backdropView: UIView!
    @IBOutlet weak var ivBackdrop: UIImageView!
    
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblBiography: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var btnMoreBiography: UIButton!
    
    @IBOutlet weak var moviesSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    @IBOutlet weak var gallerySectionHeaderView: SectionHeaderView!
    
    private var btnSearch: UIButton!
    private var btnShare: UIButton!
    
    // MARK: - Properties
    
    private let popViewTriggerS = PublishRelay<Void>()
    private let retryTriggerS = PublishRelay<Void>()
    
    private var personDetail: PersonDetail?
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureHeaderSection()
        configureMoviesSection()
        configureOthersView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = PersonDetailsViewModel.Input(
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            retryTrigger: retryTriggerS.asDriverOnErrorJustComplete(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            shareTrigger: btnShare.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.personDetail
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.personDetail = item
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
}

// MARK: - Private functions

extension PersonDetailsViewController {
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
    
    private func configureHeaderSection() {
        departmentTagListView.tagBackgroundColor = AppColors.colorYellow
        departmentTagListView.textColor = AppColors.colorPrimary
    }
    
    private func configureMoviesSection() {
        moviesSectionHeaderView.title = "movies".localized
        moviesSectionHeaderView.showSeeMoreButton = false
        
        let moviesCollectionViewLayout = UICollectionViewFlowLayout()
        moviesCollectionViewLayout.scrollDirection = .horizontal
        moviesCollectionView.collectionViewLayout = moviesCollectionViewLayout
        moviesCollectionView.register(cellWithClass: MovieHorizontalCell.self)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureOthersView() {
        ivBackdrop.kf.indicatorType = .activity
        ivProfile.kf.indicatorType = .activity
        scrollView.isHidden = true
        loadingIndicator.startAnimating()
        btnShare.isEnabled = false
        btnShare.alpha = 0.5
    }
    
    private func bindData(_ personDetail: PersonDetail) {
        lblTitle.text = personDetail.name
        
        departmentTagListView.removeAllTags()
        departmentTagListView.addTags(personDetail.departments)
        
        if let profileURL = personDetail.profileURL {
            ivProfile.kf.setImage(with: profileURL)
        }
        
        lblBiography.text = personDetail.biography
        
        let birthDayString = getBirdthdayStringFormatted(personDetail.birthday) ?? "unknown".localized
        lblBirthday.text = "DOB: \(birthDayString)"
        lblBirthday.highlight(text: birthDayString, color: AppColors.textColorSecondary)
        
        moviesCollectionView.reloadData()
    }
    
    private func getBirdthdayStringFormatted(_ strDate: String?) -> String? {
        if let strDate = strDate,
           let date = DataUtils.getApiResponseDate(strDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PersonDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personDetail?.entertainmentItems.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = personDetail?.entertainmentItems[indexPath.row] else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withClass: MovieHorizontalCell.self, for: indexPath)
        cell.bind(item)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension PersonDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = personDetail?.entertainmentItems[indexPath.row] else { return }
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PersonDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height
        let itemWidth = itemHeight * DimensionConstants.entertainmentHorizontalCellRatio
        return .init(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16.0, bottom: 0.0, right: 16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DimensionConstants.entertainmentHorizontalCellSpacing
    }
}
