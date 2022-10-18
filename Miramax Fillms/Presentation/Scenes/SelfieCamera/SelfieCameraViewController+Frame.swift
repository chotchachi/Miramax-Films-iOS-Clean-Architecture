//
//  SelfieCameraViewController+Frame.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/10/2022.
//

import Foundation
import UIKit
import Kingfisher
import Domain

extension SelfieCameraViewController {
    func setFrameImage(with item: SelfieFrame) {
        KingfisherManager.shared.retrieveImage(with: item.frameURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.frameImageView.image = value.image
                let size = value.image.suitableSize(widthLimit: UIScreen.main.bounds.width)
                self.frameImageViewHc.constant = size?.height ?? 0.0
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setMovieImage(with item: UIImage) {
        canvasImageView.removeSubviews()
        
        let imageView = UIImageView(image: item)
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = .init(width: 200, height: 200)
        imageView.center = canvasImageView.center
        
        canvasImageView.addSubview(imageView)
        
        addGestures(view: imageView)
    }
    
    private func addGestures(view: UIView) {
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(pinchGesture))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action:#selector(rotationGesture) )
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SelfieCameraViewController: UIGestureRecognizerDelegate  {
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
            view.superview?.bringSubviewToFront(view)
            view.center = CGPoint(x: view.center.x + recognizer.translation(in: canvasImageView).x,
                                  y: view.center.y + recognizer.translation(in: canvasImageView).y)
            
            recognizer.setTranslation(CGPoint.zero, in: canvasImageView)
            
            if recognizer.state == .ended {
                if !canvasImageView.bounds.contains(view.center) {
                    UIView.animate(withDuration: 0.3, animations: {
                        view.center = self.canvasImageView.center
                    })
                }
            }
        }
    }
    
    @objc private func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            if view is UITextView {
                let textView = view as! UITextView
                
                if textView.font!.pointSize * recognizer.scale < 90 {
                    let font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * recognizer.scale)
                    textView.font = font
                    let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height:CGFloat.greatestFiniteMagnitude))
                    textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                                  height: sizeToFit.height)
                } else {
                    let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height:CGFloat.greatestFiniteMagnitude))
                    textView.bounds.size = CGSize(width: textView.intrinsicContentSize.width,
                                                  height: sizeToFit.height)
                }
                
                
                textView.setNeedsDisplay()
            } else {
                view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            }
            recognizer.scale = 1
        }
    }
    
    @objc private func rotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    @objc private func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
            view.superview?.bringSubviewToFront(view)
            selectMovieImageTriggerS.accept(())
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
