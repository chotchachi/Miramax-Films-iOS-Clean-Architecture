//
//  Frame2.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 29/10/2022.
//

import UIKit

class Frame2: SelfieFrameView, SelfieFrameProtocol {
    
    // MARK: - Views
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblMovieNameShadow1: UILabel!
    @IBOutlet weak var lblMovieNameShadow2: UILabel!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var ivPosterWrap: UIView!
    
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
        let nib = UINib(nibName: "Frame2", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        
        ivPoster.isUserInteractionEnabled = true
        ivPoster.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(posterImageViewTapped(_:))))
        
        let radians = CGFloat(CGFloat(Double.pi) * CGFloat(-7) / CGFloat(180.0))
        ivPosterWrap.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    @objc private func posterImageViewTapped(_ sender: UITapGestureRecognizer) {
        onPosterImageViewTapped?()
    }
    
    func setMovieNameText(_ text: String) {
        [lblMovieName, lblMovieNameShadow1, lblMovieNameShadow2].forEach { label in
            label?.text = text
        }
    }
}
