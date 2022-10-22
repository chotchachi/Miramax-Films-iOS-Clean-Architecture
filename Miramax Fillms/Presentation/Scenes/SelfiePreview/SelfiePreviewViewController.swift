//
//  SelfiePreviewViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/10/2022.
//

import UIKit
import RxCocoa
import RxSwift
import SwifterSwift

class SelfiePreviewViewController: BaseViewController<SelfiePreviewViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ivPreview: UIImageView!
    @IBOutlet weak var btnFavorite: UIView!
    @IBOutlet weak var btnDownload: UIView!
    @IBOutlet weak var btnShare: UIView!
    
    // MARK: - Properties
    
    private var currentImage: UIImage?
    
    private let addFavoriteTriggerS = PublishRelay<Void>()
    
    // MARK: - Lifecycle

    override func configView() {
        super.configView()
        
        btnFavorite.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonFavoriteTapped(_:))))
        btnDownload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonDownloadTapped(_:))))
        btnShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonShareTapped(_:))))
    }
        
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SelfiePreviewViewModel.Input(popViewTrigger: btnBack.rx.tap.asDriver(),
                                                 addFavoriteTrigger: addFavoriteTriggerS.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.finalImage
            .drive(onNext: { [weak self] image in
                guard let self = self else { return }
                self.currentImage = image
                self.ivPreview.image = image
            })
            .disposed(by: rx.disposeBag)
        
//        output.favoriteImageState
//            .drive(onNext: { [weak self] state in
//                guard let self = self else { return }
//                switch state {
//                case .successfully:
//                    self.showAlert(title: "add_image_favorite".localized, message: "add_image_favorite_successfully".localized)
//                case .failed:
//                    self.showAlert(title: "add_image_favorite".localized, message: "add_image_favorite_failed".localized)
//                case .alreadyExist:
//                    self.showAlert(title: "add_image_favorite".localized, message: "add_image_favorite_already_exist".localized)
//                }
//            })
//            .disposed(by: rx.disposeBag)
    }
    
    @objc private func buttonFavoriteTapped(_ sender: UITapGestureRecognizer) {
        addFavoriteTriggerS.accept(())
    }
    
    @objc private func buttonDownloadTapped(_ sender: UITapGestureRecognizer) {
        guard let image = currentImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc private func buttonShareTapped(_ sender: UITapGestureRecognizer) {
        guard let image = currentImage else { return }
        var activityItems = [
            "share_image".localized,
        ] as [Any]
        activityItems.append(contentsOf: [image])
        let ac = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            ac.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            ac.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 300, height: 350)
            ac.popoverPresentationController?.permittedArrowDirections = [.any]
        }
        present(ac, animated: true)
    }
    
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            showAlert(title: "error".localized, message: "an_error_occurred".localized)
        } else {
            showAlert(title: "save_image_success_title".localized, message: "save_image_success_message".localized)
        }
    }
}
