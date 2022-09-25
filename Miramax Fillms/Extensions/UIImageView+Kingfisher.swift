//
//  UIImageView+Kingfisher.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with url: URL?) {
        kf.indicatorType = .activity
        kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
    }

    func cancelImageDownload() {
        kf.cancelDownloadTask()
    }
}
