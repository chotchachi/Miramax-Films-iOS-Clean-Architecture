//
//  MovieHorizontalCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import UIKit
import SnapKit
import Kingfisher

class MovieHorizontalCell: UICollectionViewCell {
    
    // MARK: - Views

    private var ivPoster: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // image view poster
        
        ivPoster = UIImageView()
        ivPoster.translatesAutoresizingMaskIntoConstraints = false
        ivPoster.contentMode = .scaleAspectFill
        ivPoster.clipsToBounds = true
        ivPoster.kf.indicatorType = .activity
        
        // constraint layout
        
        contentView.addSubview(ivPoster)
        ivPoster.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ item: EntertainmentModelType) {
        if let posterURL = item.entertainmentModelPosterURL {
            ivPoster.kf.setImage(with: posterURL)
        }
    }
}
