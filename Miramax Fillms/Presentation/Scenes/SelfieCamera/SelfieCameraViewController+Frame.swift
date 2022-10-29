//
//  SelfieCameraViewController+Frame.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/10/2022.
//

import Foundation
import UIKit
import Kingfisher
import SwifterSwift
import SnapKit
import RxSwift
import RxCocoa
import Domain

extension SelfieCameraViewController {
    func setFrameImage(with selfieFrame: SelfieFrame?) {
        frameView.removeSubviews()

        if let item = selfieFrame {
//            KingfisherManager.shared.retrieveImage(with: item.frameURL) { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let value):
//                    self.frameImageView.image = value.image
//                    let size = value.image.suitableSize(heightLimit: self.viewMain.height, widthLimit: self.viewMain.width)
//                    self.canvasViewWidthConstraint.constant = size.width
//                    self.canvasViewHeightConstraint.constant = size.height
//                    self.previewViewWidthConstraint.constant = size.width
//                    self.previewViewHeightConstraint.constant = size.height
//                case .failure(let error):
//                    print(error)
//                }
//            }
            let frame = Frame1()
            frame.onPosterImageViewTapped = { [weak self] in
                self?.selectMovieImageTriggerS.accept(())
            }
            frameView.addSubview(frame)
            frame.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
            
            setFrameDateText(with: Date())
        } else {
//            frameImageView.image = nil
            setCanvasViewFullSize()
        }
    }
    
    private func setCanvasViewFullSize() {
        self.canvasViewWidthConstraint.constant = viewMain.width
        self.canvasViewHeightConstraint.constant = viewMain.height
    }
    
    func setFramePosterImage(with item: EntertainmentViewModel) {
        guard let posterURL = item.posterURL else { return }
        
        KingfisherManager.shared.retrieveImage(with: posterURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                guard let frame = self.frameView.subviews.first as? SelfieFrameProtocol else { return }
                frame.setPosterImage(value.image)
            case .failure:
                break
            }
        }
    }
    
    func setFrameDateText(with date: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        guard let frame = self.frameView.subviews.first as? SelfieFrameProtocol else { return }
        frame.setDateText(date != nil ? dateFormatter.string(from: date!) : nil)
    }
    
    func setFrameLocationText(with location: String?) {
        guard let frame = self.frameView.subviews.first as? SelfieFrameProtocol else { return }
        frame.setLocationText(location)
    }
}
