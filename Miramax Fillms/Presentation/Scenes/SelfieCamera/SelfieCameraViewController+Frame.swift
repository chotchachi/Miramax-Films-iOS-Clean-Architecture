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
    func setFrame(with selfieFrame: SelfieFrame?, and movie: EntertainmentViewModel) {
        frameView.removeSubviews() /// Remove current frame view

        if let item = selfieFrame {
            KingfisherManager.shared.retrieveImage(with: item.frameURL) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    let size = value.image.suitableSize(heightLimit: self.viewMain.height, widthLimit: self.viewMain.width)
                    self.canvasViewWidthConstraint.constant = size.width
                    self.canvasViewHeightConstraint.constant = size.height
                    self.previewViewWidthConstraint.constant = size.width
                    self.previewViewHeightConstraint.constant = size.height
                case .failure(let error):
                    print(error)
                }
            }
            
            var frame: SelfieFrameView!
            
            if item.name == "Frame 1" {
                frame = Frame1()
            } else if item.name == "Frame 2" {
                frame = Frame2()
            } else if item.name == "Frame 3" {
                frame = Frame3()
            } else if item.name == "Frame 5" {
                frame = Frame5()
            } else if item.name == "Frame 6" {
                frame = Frame6()
            }
            
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
            
            setFramePosterImage(with: movie)
            setFrameDateText(with: currentFormDate ?? Date())
        } else {
            /// If selfie frame was nil
            /// Set canvas view fill main view
            canvasViewWidthConstraint.constant = viewMain.width
            canvasViewHeightConstraint.constant = viewMain.height
        }
    }
    
    private func setFramePosterImage(with item: EntertainmentViewModel) {
        guard let frame = self.frameView.subviews.first as? SelfieFrameProtocol, let posterURL = item.posterURL else { return }
        
        frame.setMovieNameText(item.name)
        
        KingfisherManager.shared.retrieveImage(with: posterURL) { result in
            switch result {
            case .success(let value):
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
