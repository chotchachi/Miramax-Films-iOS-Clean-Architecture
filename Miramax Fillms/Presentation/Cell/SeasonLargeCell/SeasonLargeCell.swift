//
//  SeasonLargeCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Kingfisher

class SeasonLargeCell: UITableViewCell {
    
    // MARK: - Views
    
    private var lblSeasonName: UILabel!
    private var lblAirDate: UILabel!
    private var lblOverview: UILabel!
    private var ivPoster: UIImageView!
    
    // MARK: - Properties
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        // View container
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.cornerRadius = 16.0
        containerView.clipsToBounds = true
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
            make.height.equalTo(containerView.snp.width).multipliedBy(DimensionConstants.seasonLargeCellRatio)
        }
        
        // Image view poster
        
        ivPoster = UIImageView()
        ivPoster.translatesAutoresizingMaskIntoConstraints = false
        ivPoster.contentMode = .scaleAspectFill
        ivPoster.kf.indicatorType = .activity
        
        containerView.addSubview(ivPoster)
        ivPoster.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // Label season name
        
        lblSeasonName = UILabel()
        lblSeasonName.translatesAutoresizingMaskIntoConstraints = false
        lblSeasonName.textColor = UIColor(hex: 0x0A1231)
        lblSeasonName.font = AppFonts.caption2
        
        let lblSeasonNameWrapView = UIView()
        lblSeasonNameWrapView.translatesAutoresizingMaskIntoConstraints = false
        lblSeasonNameWrapView.cornerRadius = 3.0
        lblSeasonNameWrapView.backgroundColor = AppColors.colorYellow
        
        lblSeasonNameWrapView.addSubview(lblSeasonName)
        lblSeasonName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(6.0)
            make.trailing.equalToSuperview().offset(-6.0)
        }

        // Label air date

        lblAirDate = UILabel()
        lblAirDate.translatesAutoresizingMaskIntoConstraints = false
        lblAirDate.textColor = .white.withAlphaComponent(0.5)
        lblAirDate.font = AppFonts.caption2
        
        // Label overview
        
        lblOverview = UILabel()
        lblOverview.translatesAutoresizingMaskIntoConstraints = false
        lblOverview.textColor = AppColors.textColorPrimary
        lblOverview.font = AppFonts.caption1Semibold
        lblOverview.numberOfLines = 2

        // Labels stack view

        let labelsStackView = UIStackView(arrangedSubviews: [lblSeasonNameWrapView, lblAirDate, lblOverview], axis: .vertical, spacing: 3.0, alignment: .leading)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        lblSeasonNameWrapView.snp.makeConstraints { make in
            make.height.equalTo(18.0)
        }
        
        containerView.addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(12.0)
            make.bottom.equalToSuperview().offset(-12.0)
            make.leading.equalToSuperview().offset(12.0)
            make.trailing.equalToSuperview().offset(-12.0)
        }
        
        // Gradient view
        
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.startColor = AppColors.colorAccent.withAlphaComponent(0.0)
        gradientView.endColor = AppColors.colorAccent
        
        containerView.insertSubview(gradientView, belowSubview: labelsStackView)
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(labelsStackView.snp.top).offset(-12.0)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(_ item: Season) {
        lblSeasonName.text = item.name

        if let airDateStr = getAirDateStringFormatted(item.airDate) {
            lblAirDate.text = airDateStr
            lblAirDate.isHidden = false
        } else {
            lblAirDate.isHidden = true
        }
        
        lblOverview.text = item.overview
        lblOverview.isHidden = item.overview.isEmpty
        
        if let posterURL = item.posterURL {
            ivPoster.kf.setImage(with: posterURL)
        }
    }
    
    private func getAirDateStringFormatted(_ strDate: String?) -> String? {
        if let strDate = strDate,
           let date = DataUtils.getApiResponseDate(strDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
