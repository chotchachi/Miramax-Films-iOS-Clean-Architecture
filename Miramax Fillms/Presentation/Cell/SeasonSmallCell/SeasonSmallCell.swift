//
//  SeasonSmallCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Kingfisher

class SeasonSmallCell: UITableViewCell {
    
    // MARK: - Views
    
    private var lblOffset: UILabel!
    private var lblSeasonName: UILabel!
    private var lblAirDate: UILabel!
    private var ivPoster: UIImageView!
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
        lblOffset.font = AppFonts.caption1Semibold
        
        contentView.addSubview(lblOffset)
        lblOffset.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        // Image view poster
        
        ivPoster = UIImageView()
        ivPoster.translatesAutoresizingMaskIntoConstraints = false
        ivPoster.contentMode = .scaleAspectFill
        ivPoster.clipsToBounds = true
        ivPoster.cornerRadius = 8.0
        ivPoster.kf.indicatorType = .activity
        
        contentView.addSubview(ivPoster)
        ivPoster.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(lblOffset.snp.trailing).offset(12.0)
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.width.equalTo(ivPoster.snp.height)
        }
        
        // Label season name
        
        lblSeasonName = UILabel()
        lblSeasonName.translatesAutoresizingMaskIntoConstraints = false
        lblSeasonName.textColor = AppColors.textColorPrimary
        lblSeasonName.font = AppFonts.caption1Semibold
        
        // Label air date
        
        lblAirDate = UILabel()
        lblAirDate.translatesAutoresizingMaskIntoConstraints = false
        lblAirDate.textColor = AppColors.textColorSecondary
        lblAirDate.font = AppFonts.caption2
        
        // Labels stack view
        
        let labelsStackView = UIStackView(arrangedSubviews: [lblAirDate, lblSeasonName], axis: .vertical, spacing: 2.0, alignment: .leading)
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(ivPoster.snp.trailing).offset(12.0)
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
            make.leading.equalTo(labelsStackView.snp.trailing).offset(16.0)
            make.height.equalTo(24.0)
            make.width.equalTo(24.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(_ item: Season, offset: Int) {
        lblOffset.text = "\(offset + 1)"
        
        lblSeasonName.text = item.name
        
        if let airDateStr = getAirDateStringFormatted(item.airDate) {
            lblAirDate.text = airDateStr
            lblAirDate.isHidden = false
        } else {
            lblAirDate.isHidden = true
        }
        
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
    
    @objc private func onPlayButtonTapped(_ sender: UIButton) {
        onPlayButtonTapped?()
    }
}
