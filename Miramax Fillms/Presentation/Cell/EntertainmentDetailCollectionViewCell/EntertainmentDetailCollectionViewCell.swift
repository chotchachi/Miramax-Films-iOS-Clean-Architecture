//
//  EntertainmentDetailCollectionViewCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Domain

class EntertainmentDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views

    private var ivPoster: UIImageView!
    private var lblName: UILabel!
    private var lblRating: UILabel!
    private var lblReleaseDate: UILabel!
    private var lblOverview: UILabel!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // Image view poster
        
        ivPoster = UIImageView()
        ivPoster.translatesAutoresizingMaskIntoConstraints = false
        ivPoster.contentMode = .scaleAspectFill
        ivPoster.cornerRadius = 16.0
        ivPoster.clipsToBounds = true
        contentView.addSubview(ivPoster)
        ivPoster.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(ivPoster.snp.height).multipliedBy(0.67)
        }
        
        // Label name
        
        lblName = UILabel()
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.textColor = AppColors.textColorPrimary
        lblName.font = AppFonts.bodySemiBold
        lblName.numberOfLines = 2
        
        // Label rating
        
        lblRating = UILabel()
        lblRating.translatesAutoresizingMaskIntoConstraints = false
        lblRating.textColor = AppColors.colorYellow
        lblRating.font = AppFonts.caption2SemiBold
        
        // Label release date
        
        lblReleaseDate = UILabel()
        lblReleaseDate.translatesAutoresizingMaskIntoConstraints = false
        lblReleaseDate.alpha = 0.8
        lblReleaseDate.textColor = AppColors.textColorPrimary
        lblReleaseDate.font = AppFonts.caption2
        
        // Label overview
        
        lblOverview = UILabel()
        lblOverview.translatesAutoresizingMaskIntoConstraints = false
        lblOverview.textColor = AppColors.textColorSecondary
        lblOverview.font = AppFonts.caption1
        lblOverview.numberOfLines = 3
        
        // Button play trailer
        
        let playTrailerView = UIView()
        playTrailerView.translatesAutoresizingMaskIntoConstraints = false
        playTrailerView.backgroundColor = .clear
        playTrailerView.cornerRadius = 16.0
        playTrailerView.borderColor = AppColors.colorAccent
        playTrailerView.borderWidth = 1.0
        
        // Label play trailer
        
        let lblPlayerTrailer = UILabel()
        lblPlayerTrailer.translatesAutoresizingMaskIntoConstraints = false
        lblPlayerTrailer.text = "play_trailer".localized
        lblPlayerTrailer.textColor = AppColors.colorAccent
        lblPlayerTrailer.font = AppFonts.caption1SemiBold
        playTrailerView.addSubview(lblPlayerTrailer)
        lblPlayerTrailer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12.0)
        }
        
        // Image view play trailer
        
        let ivPlayTrailer = UIImageView()
        ivPlayTrailer.translatesAutoresizingMaskIntoConstraints = false
        ivPlayTrailer.image = UIImage(named: "ic_play_fill")
        ivPlayTrailer.contentMode = .scaleToFill
        playTrailerView.addSubview(ivPlayTrailer)
        ivPlayTrailer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.0)
            make.bottom.equalToSuperview().offset(-4.0)
            make.width.equalTo(ivPlayTrailer.snp.height)
            make.trailing.equalToSuperview().offset(-4.0)
            make.leading.equalTo(lblPlayerTrailer.snp.trailing).offset(8.0)
        }
        
        // Details stack view
        
        let labelsCenterStackView = UIStackView(
            arrangedSubviews: [lblRating, lblReleaseDate],
            axis: .horizontal,
            spacing: 2.0
        )
        
        let detailsStackView = UIStackView(
            arrangedSubviews: [lblName, labelsCenterStackView, lblOverview, playTrailerView],
            axis: .vertical,
            spacing: 6.0,
            alignment: .leading
        )
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailsStackView)
        detailsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(ivPoster.snp.trailing).offset(12.0)
            make.trailing.equalToSuperview()
        }
        
        playTrailerView.snp.makeConstraints { make in
            make.height.equalTo(32.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivPoster.cancelImageDownload()
        ivPoster.image = nil
    }
    
    func bind(_ item: EntertainmentModelType) {
        ivPoster.setImage(with: item.entertainmentModelPosterURL)
        lblName.text = item.entertainmentModelName
        lblOverview.text = item.entertainmentModelOverview
        
        if let rating = item.entertainmentModelRating {
            let ratingText = DataUtils.getRatingText(rating)
            lblRating.setText(ratingText, before: UIImage(named: "ic_star_yellow"))
        }
        
        let releaseDateStr = getReleaseDateStringFormatted(item.entertainmentModelReleaseDate)
        lblReleaseDate.text = "• \(releaseDateStr ?? "unknown".localized)"
    }
    
    private func getReleaseDateStringFormatted(_ strDate: String?) -> String? {
        if let strDate = strDate,
           let date = DataUtils.getApiResponseDate(strDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
