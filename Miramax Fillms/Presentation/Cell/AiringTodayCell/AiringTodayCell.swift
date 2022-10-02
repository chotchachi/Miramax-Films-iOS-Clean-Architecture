//
//  AiringTodayCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Domain

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
    
    // MARK: - Properties
    
    weak var delegate: AiringTodayCellDelegate?
    private var entertainment: EntertainmentModelType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        viewMainWrap.isUserInteractionEnabled = true
        viewMainWrap.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewMainTapped(_:))))
        
        ivPoster.contentMode = .scaleAspectFill
        ivPoster.cornerRadius = 8.0
        ivPoster.clipsToBounds = true
        
        ivBackdrop.contentMode = .scaleAspectFill
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
        btnRetry.titleText = "retry".localized
        btnRetry.addTarget(self, action: #selector(btnRetryTapped(_:)), for: .touchUpInside)
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivBackdrop.cancelImageDownload()
        ivBackdrop.image = nil
        
        ivPoster.cancelImageDownload()
        ivPoster.image = nil
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
                entertainment = firstItem
                bind(firstItem)
            }
        case .error:
            loadingIndicatorView.stopAnimating()
            viewMainWrap.isHidden = true
            btnRetry.isHidden = false
        }
    }
    
    private func bind(_ item: EntertainmentModelType) {
        ivPoster.setImage(with: item.entertainmentModelPosterURL)
        ivBackdrop.setImage(with: item.entertainmentModelBackdropURL)

        lblName.text = item.entertainmentModelName
        lblDescription.text = item.entertainmentModelOverview
    }
    
    @objc private func btnRetryTapped(_ sender: UIButton) {
        loadingIndicatorView.startAnimating()
        viewMainWrap.isHidden = true
        btnRetry.isHidden = true
        delegate?.airingTodayCellRetryButtonTapped()
    }
    
    @objc private func onViewMainTapped(_ sender: UITapGestureRecognizer) {
        guard let entertainment = entertainment else { return }
        delegate?.airingTodayCell(didTapPlayButton: entertainment)
    }
}
