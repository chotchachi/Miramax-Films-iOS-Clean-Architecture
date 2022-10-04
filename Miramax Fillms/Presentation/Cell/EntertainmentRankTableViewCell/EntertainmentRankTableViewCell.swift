//
//  EntertainmentRankTableViewCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 03/10/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Domain

class EntertainmentRankTableViewCell: UITableViewCell {

    // MARK: - Views
    
    private var lblOffset: UILabel!
    private var ivIcon: UIImageView!
    private var lblName: UILabel!
    private var lblRating: UILabel!
    private var lblReleaseDate: UILabel!
    private var btnPlay: UIButton!
    
    // MARK: - Properties
    
    var onPlayButtonTapped: (() -> ())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        // Label offset
        
        lblOffset = UILabel()
        lblOffset.translatesAutoresizingMaskIntoConstraints = false
        lblOffset.textColor = AppColors.textColorPrimary
        lblOffset.font = AppFonts.caption1SemiBold
        contentView.addSubview(lblOffset)
        lblOffset.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
        }
        
        // Image view poster
        
        ivIcon = UIImageView()
        ivIcon.translatesAutoresizingMaskIntoConstraints = false
        ivIcon.contentMode = .scaleAspectFill
        ivIcon.clipsToBounds = true
        ivIcon.image = UIImage(named: "ic_tv_fill")
        ivIcon.tintColor = AppColors.textColorPrimary
        contentView.addSubview(ivIcon)
        ivIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(lblOffset.snp.trailing).offset(12.0)
            make.height.equalTo(32.0)
            make.width.equalTo(32.0)
        }
        
        // Label name
        
        lblName = UILabel()
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.textColor = AppColors.textColorPrimary
        lblName.font = AppFonts.caption1SemiBold
        
        // Label rating
        
        lblRating = UILabel()
        lblRating.translatesAutoresizingMaskIntoConstraints = false
        lblRating.textColor = AppColors.colorYellow
        lblRating.font = AppFonts.caption2SemiBold
        
        // Label release date
        
        lblReleaseDate = UILabel()
        lblReleaseDate.translatesAutoresizingMaskIntoConstraints = false
        lblReleaseDate.textColor = AppColors.textColorPrimary
        lblReleaseDate.font = AppFonts.caption2
        
        // Labels stack view
        
        let labelsBottomStackView = UIStackView(arrangedSubviews: [lblRating, lblReleaseDate], axis: .horizontal, spacing: 2.0)
        
        let labelsStackView = UIStackView(arrangedSubviews: [lblName, labelsBottomStackView], axis: .vertical, spacing: 6.0, alignment: .leading)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.leading.equalTo(ivIcon.snp.trailing).offset(12.0)
        }
        
        // Button play
        
        btnPlay = UIButton(type: .system)
        btnPlay.translatesAutoresizingMaskIntoConstraints = false
        btnPlay.setImage(UIImage(named: "ic_play_fill"), for: .normal)
        btnPlay.addTarget(self, action: #selector(onPlayButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(btnPlay)
        btnPlay.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16.0)
            make.leading.equalTo(labelsStackView.snp.trailing).offset(12.0)
            make.height.equalTo(24.0)
            make.width.equalTo(24.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(_ item: EntertainmentModelType, offset: Int) {
        lblOffset.text = "\(offset + 1)"
        lblName.text = item.entertainmentModelName
        
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
    
    @objc private func onPlayButtonTapped(_ sender: UIButton) {
        onPlayButtonTapped?()
    }
}
