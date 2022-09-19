//
//  MovieDetailsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class MovieDetailsViewController: BaseViewController<MovieDetailsViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var ivPoster: UIImageView!
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    private var btnSearch: UIButton!
    private var btnShare: UIButton!

    // MARK: - Properties
    
    private var popViewTriggerS = PublishRelay<Void>()

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
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = MovieDetailsViewModel.Input(
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            shareTrigger: btnShare.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.movieDetail
            .drive(onNext: { [weak self] movieDetail in
                guard let self = self else { return }
                self.bindData(movieDetail)
                self.scrollView.isHidden = false
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func bindData(_ movieDetail: MovieDetail) {
        lblTitle.text = movieDetail.title
        lblRating.text = DataUtils.getRatingText(movieDetail.voteAverage)
        lblDuration.text = DataUtils.getDurationText(movieDetail.runtime)
        lblReleaseDate.text = DataUtils.getReleaseYear(movieDetail.releaseDate)
        
        if let posterURL = movieDetail.posterURL {
            ivPoster.kf.setImage(with: posterURL)
        }
    }

}

// MARK: - AppToolbarDelegate

extension MovieDetailsViewController: AppToolbarDelegate {
    func appToolbar(onBackButtonTapped button: UIButton) {
        popViewTriggerS.accept(())
    }
}
