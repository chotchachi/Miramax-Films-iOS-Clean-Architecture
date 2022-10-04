//
//  EpisodeTableViewCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Domain

fileprivate let kOverviewLabelMaxLines: Int = 5

class EpisodeTableViewCell: UITableViewCell {
 
    // MARK: - Views
    
    private var ivThumbnail: UIImageView!
    private var lblAirDate: UILabel!
    private var lblEpisodeName: UILabel!
    private var lblOverview: UILabel!
    private var btnSeeMoreOverview: UIButton!
    
    // MARK: - Properties
    
    private var lblOverviewShowMore = false
    
    var onLayoutChangeNeeded: (() -> ())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        // Image view thumb
        
        ivThumbnail = UIImageView()
        ivThumbnail.translatesAutoresizingMaskIntoConstraints = false
        ivThumbnail.contentMode = .scaleAspectFill
        ivThumbnail.clipsToBounds = true
        contentView.addSubview(ivThumbnail)
        ivThumbnail.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(ivThumbnail.snp.width).multipliedBy(0.42)
        }
        
        // Label air date
        
        lblAirDate = UILabel()
        lblAirDate.translatesAutoresizingMaskIntoConstraints = false
        lblAirDate.textColor = UIColor(hex: 0x0A1231)
        lblAirDate.font = AppFonts.caption2
        
        let lblAirDateWrapView = UIView()
        lblAirDateWrapView.translatesAutoresizingMaskIntoConstraints = false
        lblAirDateWrapView.cornerRadius = 3.0
        lblAirDateWrapView.backgroundColor = AppColors.colorYellow
        lblAirDateWrapView.addSubview(lblAirDate)
        lblAirDate.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(6.0)
            make.trailing.equalToSuperview().offset(-6.0)
        }
        
        contentView.addSubview(lblAirDateWrapView)
        lblAirDateWrapView.snp.makeConstraints { make in
            make.top.equalTo(ivThumbnail.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-16.0)
            make.height.equalTo(18.0)
        }
        
        // Label episode name
        
        lblEpisodeName = UILabel()
        lblEpisodeName.translatesAutoresizingMaskIntoConstraints = false
        lblEpisodeName.textColor = AppColors.textColorPrimary
        lblEpisodeName.font = AppFonts.bodySemiBold
        lblEpisodeName.numberOfLines = 0
        contentView.addSubview(lblEpisodeName)
        lblEpisodeName.snp.makeConstraints { make in
            make.top.equalTo(lblAirDateWrapView.snp.bottom).offset(4.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }
        
        // Label overview
        
        lblOverview = UILabel()
        lblOverview.translatesAutoresizingMaskIntoConstraints = false
        lblOverview.textColor = AppColors.textColorSecondary
        lblOverview.font = AppFonts.caption1
        lblOverview.numberOfLines = kOverviewLabelMaxLines
        
        // Button see more overview
        
        btnSeeMoreOverview = UIButton(type: .system)
        btnSeeMoreOverview.setTitle("see_more".localized, for: .normal)
        btnSeeMoreOverview.titleLabel?.font = AppFonts.caption1
        btnSeeMoreOverview.contentHorizontalAlignment = .left
        btnSeeMoreOverview.setTitleColor(AppColors.colorAccent, for: .normal)
        btnSeeMoreOverview.addTarget(self, action: #selector(seeMoreOverViewButtonTapped(_:)), for: .touchUpInside)

        // Stack view details
        
        let detailsStackView = UIStackView(arrangedSubviews: [lblOverview, btnSeeMoreOverview], axis: .vertical, spacing: 4.0)
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailsStackView)
        detailsStackView.snp.makeConstraints { make in
            make.top.equalTo(lblEpisodeName.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivThumbnail.cancelImageDownload()
        ivThumbnail.image = nil
    }
    
    func bind(_ item: Episode) {
        lblEpisodeName.text = item.name
        lblAirDate.text = getAirDateStringFormatted(item.airDate) ?? "unknown".localized
        
        lblOverview.text = item.overview
        lblOverview.isHidden = item.overview.isEmpty
        btnSeeMoreOverview.isHidden = item.overview.isEmpty

        ivThumbnail.setImage(with: item.posterURL)
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
    
    @objc private func seeMoreOverViewButtonTapped(_ sender: UIButton) {
        UIView.transition(with: lblOverview, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.lblOverviewShowMore
            ? (self.lblOverview.numberOfLines = kOverviewLabelMaxLines)
            : (self.lblOverview.numberOfLines = 0)
            self.btnSeeMoreOverview.setTitle(self.lblOverviewShowMore ? "see_more".localized : "see_less".localized, for: .normal)
        }) { _ in
            self.lblOverviewShowMore.toggle()
            self.onLayoutChangeNeeded?()
        }
    }
}
