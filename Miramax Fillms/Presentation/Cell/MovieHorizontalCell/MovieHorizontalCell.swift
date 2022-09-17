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

    private var ivMoviePoster: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // image view poster
        
        ivMoviePoster = UIImageView()
        ivMoviePoster.translatesAutoresizingMaskIntoConstraints = false
        ivMoviePoster.contentMode = .scaleAspectFill
        ivMoviePoster.clipsToBounds = true
        ivMoviePoster.kf.indicatorType = .activity
        
        // constraint layout
        
        contentView.addSubview(ivMoviePoster)
        ivMoviePoster.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ movie: Movie) {
        if let posterURL = movie.posterURL {
            ivMoviePoster.kf.setImage(with: posterURL)
        }
    }
}
