//
//  AiringTodayCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Kingfisher

class AiringTodayCell: UICollectionViewCell {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var viewMainWrap: UIView!
    @IBOutlet weak var ivBackdrop: UIImageView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var viewPosterWrap: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    private var loadingIndicatorView: UIActivityIndicatorView!
    private var btnRetry: PrimaryButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        ivPoster.contentMode = .scaleAspectFill
        ivPoster.kf.indicatorType = .activity
        ivPoster.cornerRadius = 8.0
        ivPoster.clipsToBounds = true
        
        ivBackdrop.contentMode = .scaleAspectFill
        ivBackdrop.kf.indicatorType = .activity
        ivBackdrop.clipsToBounds = true
        
        lblName.font = AppFonts.subheadSemiBold
        lblName.textColor = AppColors.textColorPrimary
        
        lblDescription.font = AppFonts.caption1
        lblDescription.textColor = AppColors.textColorPrimary
        
        viewPosterWrap.cornerRadius = 8.0
        viewPosterWrap.borderColor = AppColors.colorAccent
        viewPosterWrap.borderWidth = 1.0
        viewPosterWrap.shadowColor = UIColor.black.withAlphaComponent(0.2)
        viewPosterWrap.shadowOffset = .init(width: 0.0, height: 2.0)
        viewPosterWrap.shadowRadius = 10.0
        viewPosterWrap.shadowOpacity = 1.0
        viewPosterWrap.layer.masksToBounds = false
        
        // loading indicator
        
        loadingIndicatorView = UIActivityIndicatorView(style: .white)
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        // retry button
        
        btnRetry = PrimaryButton()
        btnRetry.titleText = "Retry"
        btnRetry.addTarget(self, action: #selector(btnRetryTapped), for: .touchUpInside)
        
        // constraint layout
        
        contentView.addSubview(loadingIndicatorView)
        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(btnRetry)
        btnRetry.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func bind(_ viewState: ViewState<TVShow>) {
        switch viewState {
        case .initial:
            loadingIndicatorView.startAnimating()
            viewMainWrap.isHidden = true
            btnRetry.isHidden = true
        case .paging:
            break
        case .populated(let array):
            loadingIndicatorView.stopAnimating()
            viewMainWrap.isHidden = false
            btnRetry.isHidden = true
            // set data
            if let firstItem = array.first {
                bind(firstItem)
            }
        case .empty:
            break
        case .error:
            loadingIndicatorView.stopAnimating()
            viewMainWrap.isHidden = true
            btnRetry.isHidden = false
        }
    }
    
    private func bind(_ item: EntertainmentModelType) {
        if let thumbURL = item.thumbImageURL {
            ivPoster.kf.setImage(with: thumbURL)
        }
        if let backdropURL = item.backdropImageURL {
            ivBackdrop.kf.setImage(with: backdropURL)
        }
        lblName.text = item.textName
        lblDescription.text = item.textDescription
    }
    
    @objc private func btnRetryTapped() {
        loadingIndicatorView.startAnimating()
        viewMainWrap.isHidden = true
        btnRetry.isHidden = true
//        delegate?.movieHorizontalListRetryButtonTapped()
    }
}
