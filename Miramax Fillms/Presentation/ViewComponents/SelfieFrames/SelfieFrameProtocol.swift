//
//  SelfieFrameProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/10/2022.
//

import UIKit

protocol SelfieFrameProtocol {
    var ivPoster: UIImageView! { get set }
    var lblDate: UILabel! { get set }
    var lblLocation: UILabel! { get set }
        
    func setPosterImage(_ image: UIImage)
    func setDateText(_ text: String?)
    func setLocationText(_ text: String?)
}

extension SelfieFrameProtocol {
    func setPosterImage(_ image: UIImage) {
        ivPoster.image = image
    }
    
    func setDateText(_ text: String?) {
        lblDate.text = text
    }
    
    func setLocationText(_ text: String?) {
        lblLocation.text = text
    }
}
