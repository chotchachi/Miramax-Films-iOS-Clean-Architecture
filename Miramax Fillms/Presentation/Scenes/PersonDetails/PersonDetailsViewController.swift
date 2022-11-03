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
import TagListView
import Domain

class PersonDetailsViewController: BaseViewController<PersonDetailsViewModel>, LoadingDisplayable, ErrorRetryable, Searchable, Shareable {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// Section title
    @IBOutlet weak var sectionTitleView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var departmentTagListView: TagListView!
    @IBOutlet weak var btnBookmark: BookmarkButton!
    
    /// Section backdrop image
    @IBOutlet weak var sectionBackdropView: UIView!
    @IBOutlet weak var ivBackdrop: UIImageView!
    
    /// Section profile info
    @IBOutlet weak var sectionProfileInfoView: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblBiography: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var btnMoreBiography: UIButton!
    
    /// Section gallery
    @IBOutlet weak var sectionGalleryView: UIView!
    @IBOutlet weak var gallerySectionHeaderView: SectionHeaderView!
    @IBOutlet weak var ivGalleryLargeThumb: UIImageView!
    @IBOutlet weak var ivGallerySmallThumb1: UIImageView!
    @IBOutlet weak var ivGallerySmallThumb2: UIImageView!
    @IBOutlet weak var ivGallerySmallThumb3: UIImageView!

    /// Section movies
    @IBOutlet weak var sectionMoviesView: UIView!
    @IBOutlet weak var moviesSectionHeaderView: SectionHeaderView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionViewHeightConstraint: NSLayoutConstraint!

    var btnSearch: SearchButton = SearchButton()
    var btnShare: ShareButton = ShareButton()
    var loaderView: LoadingView = LoadingView()
    var errorRetryView: ErrorRetryView = ErrorRetryView()
    
    // MARK: - Properties
    
    private let entertainmentSelectTriggerS = PublishRelay<EntertainmentViewModel>()
    private let viewImageTriggerS = PublishRelay<(UIView, UIImage)>()

    private let entertainmentDataS = BehaviorRelay<[EntertainmentViewModel]>(value: [])
    
    override func configView() {
        super.configView()
        
        configureAppToolbar()
        configureTitleSection()
        configureProfileInfoSection()
        configureGallerySection()
        configureMoviesSection()
        configureOthersView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = PersonDetailsViewModel.Input(
            popViewTrigger: appToolbar.rx.backButtonTap.asDriver(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            shareTrigger: btnShare.rx.tap.asDriver(),
            toBiographyTrigger: btnMoreBiography.rx.tap.asDriver(),
            entertainmentSelectTrigger: entertainmentSelectTriggerS.asDriverOnErrorJustComplete(),
            toggleBookmarkTrigger: btnBookmark.rx.tap.asDriver(),
            viewImageTrigger: viewImageTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.personViewModel
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.bindData(item)
                self.scrollView.isHidden = false
                self.btnShare.isEnabled = true
                self.btnShare.alpha = 1.0
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
}

// MARK: - Private functions

extension PersonDetailsViewController {
    private func configureAppToolbar() {
        appToolbar.showTitleLabel = false
        appToolbar.rightButtons = [btnSearch, btnShare]
    }
    
    private func configureTitleSection() {
        lblTitle.textColor = AppColors.textColorPrimary
        lblTitle.font = AppFonts.headlineSemiBold
        
        departmentTagListView.tagBackgroundColor = AppColors.colorYellow
        departmentTagListView.textColor = AppColors.colorPrimary
        departmentTagListView.textFont = AppFonts.caption2
    }
    
    private func configureProfileInfoSection() {
        lblBiography.textColor = AppColors.textColorSecondary
        lblBiography.font = AppFonts.caption1
        
        lblBirthday.textColor = AppColors.textColorPrimary
        lblBirthday.font = AppFonts.caption1Bold
    }
    
    private func configureMoviesSection() {
        moviesSectionHeaderView.title = "movies".localized
        moviesSectionHeaderView.showActionButton = false
        
        let moviesCollectionViewLayout = UICollectionViewFlowLayout()
        moviesCollectionViewLayout.scrollDirection = .horizontal
        moviesCollectionView.collectionViewLayout = moviesCollectionViewLayout
        moviesCollectionView.register(cellWithClass: EntertainmentHorizontalCell.self)
        moviesCollectionView.delegate = self
        moviesCollectionView.showsHorizontalScrollIndicator = false
        moviesCollectionView.rx.modelSelected(EntertainmentViewModel.self)
            .bind(to: entertainmentSelectTriggerS)
            .disposed(by: rx.disposeBag)
        
        moviesCollectionViewHeightConstraint.constant = DimensionConstants.entertainmentHorizontalCollectionViewHeightConstraint
        
        let movieDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, EntertainmentViewModel>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: EntertainmentHorizontalCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        entertainmentDataS
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: moviesCollectionView.rx.items(dataSource: movieDataSource))
            .disposed(by: rx.disposeBag)
    }
    
    private func configureGallerySection() {
        gallerySectionHeaderView.title = "gallery".localized
        gallerySectionHeaderView.actionButtonTittle = "see_more".localized
        
        [ivGalleryLargeThumb, ivGallerySmallThumb1, ivGallerySmallThumb2, ivGallerySmallThumb3].forEach { view in
            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(galleryImageViewTapped(_:))))
        }
    }
    
    private func configureOthersView() {
        scrollView.isHidden = true
        btnShare.isEnabled = false
        btnShare.alpha = 0.5
    }
    
    private func bindData(_ item: PersonViewModel) {
        // Person title
        lblTitle.text = item.name
        
        // Person departments
        departmentTagListView.removeAllTags()
        departmentTagListView.addTags(item.departments ?? [])
        
        // Person is bookmark
        btnBookmark.isBookmark = item.isBookmark
        
        // Person backdrop image
        if let backdropImage = item.images?.randomElement() {
            ivBackdrop.setImage(with: backdropImage.fileURL)
            sectionBackdropView.isHidden = false
        } else {
            sectionBackdropView.isHidden = true
        }
        
        // Person profile image
        ivProfile.setImage(with: item.profileURL)
        
        // Person biography
        lblBiography.text = item.biography
        
        // Person birthday
        let birthDayString = getBirdthdayStringFormatted(item.birthday) ?? "unknown".localized
        lblBirthday.text = "DOB: \(birthDayString)"
        lblBirthday.highlight(text: birthDayString, font: AppFonts.caption1)
        
        // Person movies
        entertainmentDataS.accept(getCombineCastEntertainment(from: item))
        
        // Person gallery
        if let images = item.images {
            sectionGalleryView.isHidden = false
            [ivGalleryLargeThumb, ivGallerySmallThumb1, ivGallerySmallThumb2, ivGallerySmallThumb3].enumerated().forEach { offset, view in
                view?.setImage(with: images[safe: offset]?.fileURL)
            }
        } else {
            sectionGalleryView.isHidden = true
        }
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
    
    private func getCombineCastEntertainment(from person: PersonViewModel) -> [EntertainmentViewModel] {
        let castMovies = person.castMovies ?? []
        let castTvShows = person.castTVShows ?? []
        return castMovies + castTvShows
    }
    
    @objc private func galleryImageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView, let image = imageView.image else { return }
        viewImageTriggerS.accept((imageView, image))
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
