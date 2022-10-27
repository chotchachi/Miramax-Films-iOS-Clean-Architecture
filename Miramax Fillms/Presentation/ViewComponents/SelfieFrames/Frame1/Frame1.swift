//
//  Frame1.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/10/2022.
//

import UIKit

class Frame1: UIView, SelfieFrameProtocol {
    
    // MARK: - Views
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    // MARK: - Properties
    
    var onPosterImageViewTapped: (() -> Void)?

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "Frame1", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        
        ivPoster.isUserInteractionEnabled = true
        ivPoster.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(posterImageViewTapped(_:))))
    }
    
    @objc private func posterImageViewTapped(_ sender: UITapGestureRecognizer) {
        onPosterImageViewTapped?()
    }
}
