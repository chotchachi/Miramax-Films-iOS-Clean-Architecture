//
//  PersonDetailCollectionViewCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 09/10/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Domain

class PersonDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views

    private var ivPoster: UIImageView!
    private var lblName: UILabel!
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
        
        let detailsStackView = UIStackView(
            arrangedSubviews: [lblName, lblOverview],
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivPoster.cancelImageDownload()
        ivPoster.image = nil
    }
    
    func bind(_ item: BookmarkPerson) {
        ivPoster.setImage(with: item.profileURL)
        lblName.text = item.name
        lblOverview.text = item.biography
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
