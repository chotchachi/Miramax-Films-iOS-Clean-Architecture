//
//  SelfieCameraViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/10/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import RxCocoa
import RxSwift
import AVFoundation
import Kingfisher
import Domain

enum CameraDevice {
    case back, front
}

class SelfieCameraViewController: BaseViewController<SelfieCameraViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var previewView: UIView!
    
    /// To hold capture image, frame image, movie poster image
    /// Using to export the final image
    @IBOutlet weak var canvasView: UIView!

    /// To hold capture image
    @IBOutlet weak var captureImageView: UIImageView!

    /// To hold frame image
    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var frameImageViewHc: NSLayoutConstraint!
    
    /// To hold movie poster image
    @IBOutlet weak var canvasImageView: UIImageView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSwitchCamera: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnMoreOption: UIButton!
    
    @IBOutlet weak var viewCameraControls: UIView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnFrameLayer: UIView!
    
    @IBOutlet weak var viewFrameLayer: UIView!

    @IBOutlet weak var viewDoneCapture: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnRetake: UIButton!

    var noPermissionView: UIView!
    
    // MARK: - Properties
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var currentCameraDevice: CameraDevice = .front
    var isConfiguringCamera: Bool = false {
        didSet {
            updateCameraViewsState(isEnable: !isConfiguringCamera)
        }
    }
    
    private var isViewAppear: Bool = false
    
    let selectMovieImageTriggerS = PublishRelay<Void>()
    
    // MARK: - Lifecycle

    override func configView() {
        super.configView()
        
        configureViews()
        setupLivePreview()
        updateCameraViewsState(isEnable: false)
        setButtonFlash(isEnable: currentCameraDevice == .back)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SelfieCameraViewModel.Input(
            popViewTrigger: btnBack.rx.tap.asDriver(),
            selectMovieImageTrigger: selectMovieImageTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.selfieFrame
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.setFrameImage(with: item)
            })
            .disposed(by: rx.disposeBag)
        
        output.movieImage
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.setMovieImage(with: item)
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isViewAppear {
            checkCameraPermission {
                self.startNewCapture()
                self.isViewAppear = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        videoPreviewLayer.frame = previewView.bounds
    }
}

// MARK: - Private functions

extension SelfieCameraViewController {
    private func configureViews() {
        btnCapture.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.snapPhoto()
            })
            .disposed(by: rx.disposeBag)
        
        btnFlash.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleFlash()
            })
            .disposed(by: rx.disposeBag)
        
        btnSwitchCamera.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.switchCameraDevice()
            })
            .disposed(by: rx.disposeBag)
        
        btnRetake.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.startNewCapture()
            })
            .disposed(by: rx.disposeBag)
        
//        btnGallery.rx.tap
//            .subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                self.presentImagePickerController()
//            })
//            .disposed(by: rx.disposeBag)
        
        btnFrameLayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onButtonFrameLayerTapped(_:))))
        
        captureImageView.contentMode = .scaleAspectFill
    }
    
    private func presentImagePickerController() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func onButtonFrameLayerTapped(_ sender: UITapGestureRecognizer) {
        // test
        presentImagePickerController()
    }
    
    func handleDoneCaptureView() {
        viewCameraControls.isHidden = true
        viewFrameLayer.isHidden = true
        viewDoneCapture.isHidden = false
        btnFlash.isHidden = true
        btnSwitchCamera.isHidden = true
        
        captureImageView.isHidden = false
        
        stopCamera()
    }
    
    func startNewCapture() {
        viewCameraControls.isHidden = false
        btnFlash.isHidden = false
        btnSwitchCamera.isHidden = false
        
        viewFrameLayer.isHidden = true
        viewDoneCapture.isHidden = true
        
        captureImageView.image = nil // clear capture image
        captureImageView.isHidden = true

        setupCamera()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SelfieCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            guard let image = info[.originalImage] as? UIImage else {
                self.showAlert(title: "error".localized, message: "error_importing_image".localized)
                return
            }
            self.handleDoneCaptureView()
            self.captureImageView.image = image
        }
    }
}
