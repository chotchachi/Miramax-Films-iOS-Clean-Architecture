//
//  EntertainmentPreviewCollectionViewCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift

class EntertainmentPreviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views

    private var ivPoster: UIImageView!
    private var lblName: UILabel!
    private var lblRating: UILabel!
    private var lblDescription: UILabel!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // Container view
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.cornerRadius = 16.0
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // Image view poster
        
        ivPoster = UIImageView()
        ivPoster.translatesAutoresizingMaskIntoConstraints = false
        ivPoster.contentMode = .scaleAspectFill
        ivPoster.clipsToBounds = true
        containerView.addSubview(ivPoster)
        ivPoster.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        // Bottom wrap view
        
        let bottomWrapView = UIView()
        bottomWrapView.translatesAutoresizingMaskIntoConstraints = false
        bottomWrapView.backgroundColor = AppColors.colorAccent.withAlphaComponent(0.4)
        bottomWrapView.cornerRadius = 16.0
        bottomWrapView.clipsToBounds = true
        containerView.addSubview(bottomWrapView)
        bottomWrapView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // Bottom visual view
        
        let bottomVisualView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        bottomVisualView.translatesAutoresizingMaskIntoConstraints = false
        bottomVisualView.alpha = 0.5
        bottomWrapView.addSubview(bottomVisualView)
        bottomVisualView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        // Button play
        
        let ivPlay = UIImageView(image: UIImage(named: "ic_play_fill"))
        ivPlay.translatesAutoresizingMaskIntoConstraints = false
        ivPlay.contentMode = .scaleToFill
        ivPlay.clipsToBounds = true
        containerView.addSubview(ivPlay)
        ivPlay.snp.makeConstraints { make in
            make.height.equalTo(32.0)
            make.width.equalTo(32.0)
            make.trailing.equalToSuperview().offset(-6.0)
            make.centerY.equalTo(bottomWrapView.snp.top)
        }
        
        // Label name
        
        lblName = UILabel()
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.textColor = AppColors.textColorPrimary
        lblName.font = AppFonts.caption1SemiBold
        bottomWrapView.addSubview(lblName)
        lblName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().offset(-37.0)
        }
        
        // Label rating
        
        lblRating = UILabel()
        lblRating.translatesAutoresizingMaskIntoConstraints = false
        lblRating.textColor = AppColors.colorYellow
        lblRating.font = AppFonts.caption2SemiBold
        bottomWrapView.addSubview(lblRating)
        lblRating.snp.makeConstraints { make in
            make.top.equalTo(lblName.snp.bottom).offset(6.0)
            make.leading.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-12.0)
        }
        
        // Label description
        
        lblDescription = UILabel()
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.alpha = 0.8
        lblDescription.textColor = AppColors.textColorPrimary
        lblDescription.font = AppFonts.caption2
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
        lblRating.attributedText = setRatingLabel(ratingText: DataUtils.getRatingText(7.5))
    }
    
    private func setRatingLabel(ratingText: String) -> NSAttributedString? {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "ic_star_yellow")
        // Set bound to reposition
        imageAttachment.bounds = CGRect(x: 0.0, y: -1.5, width: 12.0, height: 12.0)
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add your text to mutable string
        let textBeforeIcon = NSAttributedString(string: ratingText)
        completeText.append(textBeforeIcon)
        // Add image to mutable string
        completeText.append(attachmentString)
        return completeText
    }
}
