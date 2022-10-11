//
//  EntertainmentWishlistCollectionViewCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 09/10/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Domain

class EntertainmentWishlistCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    // MARK: - Views

    private var ivPoster: UIImageView!
    private var lblName: UILabel!
    private var lblRating: UILabel!
    private var lblReleaseDate: UILabel!
    private var lblOverview: UILabel!
    
    private var revealView: UIView?
    private var snapShotView: UIView?
    
    // MARK: - Properties
    
    var onDeleteButtonTapped: (()->())?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // Image view poster
        
        ivPoster = UIImageView()
        ivPoster.translatesAutoresizingMaskIntoConstraints = false
        ivPoster.contentMode = .scaleAspectFill
        ivPoster.cornerRadius = 16.0
        ivPoster.clipsToBounds = true
        contentView.addSubview(ivPoster)
        ivPoster.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(ivPoster.snp.height).multipliedBy(0.67)
        }
        
        // Label name
        
        lblName = UILabel()
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.textColor = AppColors.textColorPrimary
        lblName.font = AppFonts.bodySemiBold
        lblName.numberOfLines = 2
        
        // Label rating
        
        lblRating = UILabel()
        lblRating.translatesAutoresizingMaskIntoConstraints = false
        lblRating.textColor = AppColors.colorYellow
        lblRating.font = AppFonts.caption2SemiBold
        
        // Label release date
        
        lblReleaseDate = UILabel()
        lblReleaseDate.translatesAutoresizingMaskIntoConstraints = false
        lblReleaseDate.alpha = 0.8
        lblReleaseDate.textColor = AppColors.textColorPrimary
        lblReleaseDate.font = AppFonts.caption2
        
        // Label overview
        
        lblOverview = UILabel()
        lblOverview.translatesAutoresizingMaskIntoConstraints = false
        lblOverview.textColor = AppColors.textColorSecondary
        lblOverview.font = AppFonts.caption1
        lblOverview.numberOfLines = 3
        
        // Details stack view
        
        let labelsCenterStackView = UIStackView(
            arrangedSubviews: [lblRating, lblReleaseDate],
            axis: .horizontal,
            spacing: 2.0
        )
        
        let detailsStackView = UIStackView(
            arrangedSubviews: [lblName, labelsCenterStackView, lblOverview],
            axis: .vertical,
            spacing: 6.0,
            alignment: .leading
        )
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailsStackView)
        detailsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(ivPoster.snp.trailing).offset(12.0)
            make.trailing.equalToSuperview()
        }
        
        configureGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivPoster.cancelImageDownload()
        ivPoster.image = nil
        
        snapShotView?.removeFromSuperview()
        snapShotView = nil
        revealView?.removeFromSuperview()
        
        contentView.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let revealView = revealView else { return }
        revealView.frame = CGRect(origin: CGPoint(x: frame.width - revealView.frame.width, y: 0), size: revealView.frame.size)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isMember(of: UIPanGestureRecognizer.self) {
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let velocity = gesture.velocity(in: self)
            if abs(velocity.x) > abs(velocity.y) {
                return true
            }
        }
        return false
    }
    
    private func configureGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    func bind(_ item: EntertainmentViewModel) {
        ivPoster.setImage(with: item.posterURL)
        lblName.text = item.name
        lblOverview.text = item.overview
        
        let ratingText = DataUtils.getRatingText(item.rating)
        lblRating.setText(ratingText, before: UIImage(named: "ic_star_yellow"))
        
        let releaseDateStr = getReleaseDateStringFormatted(item.releaseDate)
        lblReleaseDate.text = "• \(releaseDateStr ?? "unknown".localized)"
    }
    
    private func getReleaseDateStringFormatted(_ strDate: String?) -> String? {
        if let strDate = strDate,
           let date = DataUtils.getApiResponseDate(strDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

// MARK: - Private functions

extension EntertainmentWishlistCollectionViewCell {
    @objc private func handlePanGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if revealView == nil { createRevealView() }
            if snapShotView == nil { createSnapShotView() }
            closeOtherOpeningCell()
            addSubview(revealView!)
            guard let snapShotView = snapShotView else { return }
            addSubview(snapShotView)
            contentView.isHidden = true
        case .changed:
            let translationPoint = sender.translation(in: self)
            var centerPoint = CGPoint(x: 0, y: snapShotView!.center.y)
            centerPoint.x = min(frame.width / 2, max(snapShotView!.center.x + translationPoint.x, frame.width/2 - revealView!.frame.width + 15.0))
            sender.setTranslation(CGPoint.zero, in: self)
            snapShotView!.center = centerPoint
        case .ended, .cancelled:
            let velocity = sender.velocity(in: self)
            if bigThenRevealViewHalfWidth() || shouldShowRevealView(forVelocity: velocity) {
                showRevealView(withAnimated: true)
            }
            if lessThenRevealViewHalfWidth() || shouldHideRevealView(forVelocity: velocity) {
                hideRevealView(withAnimated: true)
            }
        default: break
        }
    }
    
    private func closeOtherOpeningCell() {
        guard let superCollectionView = superView(of: UICollectionView.self) else { return }
        
        if superCollectionView.openingCell != self {
            superCollectionView.openingCell?.hideRevealView(withAnimated: true)
            superCollectionView.openingCell = self
        }
    }
    
    private func createRevealView() {
        let deleteButton = UIButton(type: .system)
        deleteButton.frame = CGRect(x: bounds.height, y: 0, width: 100.0, height: bounds.height)
        deleteButton.backgroundColor = AppColors.colorAccent
        deleteButton.setTitle("delete".localized, for: .normal)
        deleteButton.setTitleColor(AppColors.textColorPrimary, for: .normal)
        deleteButton.titleLabel?.font = AppFonts.caption1SemiBold
        deleteButton.roundCorners([.topRight, .bottomRight], radius: 16.0)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        revealView = deleteButton
    }
    
    private func createSnapShotView() {
        snapShotView = snapshotView(afterScreenUpdates: false)
        snapShotView?.backgroundColor = AppColors.colorTertiary
        snapShotView?.cornerRadius = 16.0
        snapShotView?.isUserInteractionEnabled = true
        snapShotView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(snapShotViewTapped(_:))))
    }
    
    @objc private func snapShotViewTapped(_ sender: UITapGestureRecognizer) {
        hideRevealView(withAnimated: true)
    }
    
    private func shouldHideRevealView(forVelocity velocity: CGPoint) -> Bool {
        guard let revealView = revealView else { return false }
        return abs(velocity.x) > revealView.frame.width / 2 && velocity.x > 0
    }
    
    private func shouldShowRevealView(forVelocity velocity: CGPoint) -> Bool {
        guard let revealView = revealView else { return false }
        return abs(velocity.x) > revealView.frame.width / 2 && velocity.x < 0;
    }
    
    private func bigThenRevealViewHalfWidth() -> Bool {
        guard let revealView = revealView, let snapShotView = snapShotView else { return false }
        return abs(snapShotView.frame.width) >= revealView.frame.width / 2
    }
    
    private func lessThenRevealViewHalfWidth() -> Bool {
        guard let revealView = revealView, let snapShotView = snapShotView else { return false }
        return abs(snapShotView.frame.width) < revealView.frame.width / 2
    }
    
    private func hideRevealView(withAnimated isAnimated: Bool) {
        UIView.animate(
            withDuration: isAnimated ? 0.1 : 0,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.snapShotView?.center = CGPoint(x: self.frame.width / 2, y: self.snapShotView!.center.y)
            }, completion: { _ in
                self.snapShotView?.removeFromSuperview()
                self.snapShotView = nil
                self.revealView?.removeFromSuperview()
                self.contentView.isHidden = false
            })
    }
    
    private func showRevealView(withAnimated isAnimated: Bool) {
        UIView.animate(
            withDuration: isAnimated ? 0.1 : 0,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.snapShotView?.center = CGPoint(x: self.frame.width / 2 - self.revealView!.frame.width + 15.0 , y: self.snapShotView!.center.y)
            }
        )
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        hideRevealView(withAnimated: true)
        onDeleteButtonTapped?()
    }
}

fileprivate extension UICollectionView {
    struct AssociatedKeys {
        static var currentcell = "currentCell"
    }
    var openingCell: EntertainmentWishlistCollectionViewCell? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.currentcell) as? EntertainmentWishlistCollectionViewCell
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.currentcell,
                    newValue as EntertainmentWishlistCollectionViewCell?,
                    .OBJC_ASSOCIATION_ASSIGN
                )
            }
        }
    }
}
