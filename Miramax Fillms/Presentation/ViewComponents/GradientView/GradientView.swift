//
//  GradientView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import UIKit

@IBDesignable class GradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var startColor: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        gradientLayer = layer as? CAGradientLayer
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
    }
    
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        gradientLayer?.add(animation, forKey: "animateGradient")
    }
}
