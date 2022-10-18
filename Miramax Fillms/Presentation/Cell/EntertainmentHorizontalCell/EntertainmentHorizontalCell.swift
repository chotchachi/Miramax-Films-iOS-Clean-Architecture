//
//  EntertainmentHorizontalCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import UIKit
import SnapKit
import Domain

class EntertainmentHorizontalCell: UICollectionViewCell {
    
    // MARK: - Views

    private var ivPoster: UIImageView!
    private var viewSelected: UIView!
    
    // MARK: - Properties
    
    private var canSelection: Bool = false
    
    override var isSelected: Bool {
        didSet {
            guard canSelection else { return }
            UIView.transition(
                with: viewSelected,
                duration: 0.2,
                options: .transitionCrossDissolve
            ) { [weak self] in
                guard let self = self else { return }
                self.viewSelected.isHidden = !self.isSelected
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // Image view poster
        
        ivPoster = UIImageView()
        ivPoster.translatesAutoresizingMaskIntoConstraints = false
        ivPoster.contentMode = .scaleAspectFill
        ivPoster.clipsToBounds = true
        contentView.addSubview(ivPoster)
        ivPoster.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        // View selected
        
        viewSelected = UIView()
        viewSelected.translatesAutoresizingMaskIntoConstraints = false
        viewSelected.backgroundColor = AppColors.colorAccent.withAlphaComponent(0.3)
        viewSelected.isHidden = true
        contentView.addSubview(viewSelected)
        viewSelected.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let ivSelected = UIImageView(image: UIImage(named: "ic_circle_check"))
        ivSelected.translatesAutoresizingMaskIntoConstraints = false
        ivSelected.tintColor = .white
        viewSelected.addSubview(ivSelected)
        ivSelected.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(24.0)
            make.width.equalTo(24.0)
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
    
    func bind(_ item: EntertainmentViewModel, canSelection: Bool = false) {
        ivPoster.setImage(with: item.posterURL)
        self.canSelection = canSelection
    }
}
