//
//  EntertainmentHorizontalCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import UIKit
import SnapKit

class EntertainmentHorizontalCell: UICollectionViewCell {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivPoster.cancelImageDownload()
        ivPoster.image = nil
    }
    
    func bind(_ item: EntertainmentModelType) {
        ivPoster.setImage(with: item.entertainmentModelPosterURL)
    }
}
