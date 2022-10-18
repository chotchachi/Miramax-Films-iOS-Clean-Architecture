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
    
    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var frameImageViewHc: NSLayoutConstraint!
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var canvasImageView: UIImageView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSwitchCamera: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnMoreOption: UIButton!
    
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnFrameLayer: UIView!

    private var noPermissionView: UIView!
    
    // MARK: - Properties
    
    private var captureSession: AVCaptureSession!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private var currentCameraDevice: CameraDevice = .back
    private var isConfiguringCamera: Bool = false {
        didSet {
            updateCameraViewsState(isEnable: !isConfiguringCamera)
        }
    }
    private var isViewAppear: Bool = false
    
    private let selectMovieImageTriggerS = PublishRelay<Void>()
    
    // MARK: - Lifecycle

    override func configView() {
        super.configView()
        
        configureViews()
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
                self.setupCamera()
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
        
//        btnGallery.rx.tap
//            .subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                self.presentImagePickerController()
//            })
//            .disposed(by: rx.disposeBag)
        
        btnFrameLayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onButtonFrameLayerTapped(_:))))
        
        // Setup live preview
        
        setupLivePreview()
        
        // Disable camera view
        
        updateCameraViewsState(isEnable: false)
    }
    
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer()
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
    }
    
    private func updateCameraViewsState(isEnable: Bool) {
        DispatchQueue.main.async {
            [self.btnCapture, self.btnSwitchCamera].forEach { button in
                button?.isEnabled = isEnable
            }
        }
    }
    
    private func setupCamera() {
        isConfiguringCamera = true
        
        /// Init capture session
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        videoPreviewLayer.session = captureSession
        
        /// Get current camera device
        guard let cameraDevice = getCameraDevice() else { return }
        
        /// Add capture device output
        stillImageOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        
        /// Add capture device input
        addCaptureDeviceInput(cameraDevice) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self ] in
                self?.captureSession.startRunning()
            }
        }
    }
    
    private func addCaptureDeviceInput(_ cameraDevice: AVCaptureDevice, completion: () -> ()) {
        do {
            let input = try AVCaptureDeviceInput(device: cameraDevice)
                        
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                isConfiguringCamera = false
                completion()
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                self.showAlert(title: "error".localized, message: "initialize_camera_device_error".localized)
            }
        }
    }
    
    private func switchCameraDevice() {
        isConfiguringCamera = true
        
        /// Toggle camera device
        currentCameraDevice = currentCameraDevice == .back ? .front : .back

        /// Get new camera device
        guard let newCameraDevice = getCameraDevice() else { return }
                
        captureSession.beginConfiguration()
        
        /// Remove current capture device input if exist
        if let currentCameraInput = captureSession.inputs.first {
            captureSession.removeInput(currentCameraInput)
        }
        
        /// Add capture device input
        addCaptureDeviceInput(newCameraDevice) { }
        
        captureSession.commitConfiguration()
    }
    
    private func getCameraDevice() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: currentCameraDevice == .back ? .back : .front
        ).devices.first {
            return device
        } else {
            DispatchQueue.main.async {
                self.showAlert(title: "error".localized, message: "get_camera_device_error".localized)
            }
            return nil
        }
    }
    
    private func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == .on) {
                device.torchMode = .off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    private func snapPhoto() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
        
    private func checkCameraPermission(completion: @escaping () -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                DispatchQueue.main.async {
                    completion()
                }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    guard let self = self else { return }
                    if granted {
                        DispatchQueue.main.async {
                            completion()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.visibleNoCameraPermissionView()
                        }
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                    self.visibleNoCameraPermissionView()
                }
            case .restricted:
                DispatchQueue.main.async {
                    self.showAlert(title: "camera_restricted_alert_title".localized, message: "camera_restricted_alert_message".localized)
                }
            default:
                break
        }
    }
    
    private func visibleNoCameraPermissionView() {
        /// View no permission
        
        noPermissionView = UIView()
        noPermissionView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(noPermissionView, aboveSubview: previewView)
        noPermissionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        /// Button grant permission
        
        let btnGrantPermission = UIButton(type: .system)
        btnGrantPermission.translatesAutoresizingMaskIntoConstraints = false
        btnGrantPermission.setTitle("grant".localized, for: .normal)
        btnGrantPermission.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.openAppSetting()
            })
            .disposed(by: rx.disposeBag)
        
        noPermissionView.addSubview(btnGrantPermission)
        btnGrantPermission.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /// Label grant permission
        
        let lblGrantPermission = UILabel()
        lblGrantPermission.translatesAutoresizingMaskIntoConstraints = false
        lblGrantPermission.text = "no_camera_permisison_grant_access".localized
//        lblGrantPermission.font = AppFonts.body3
        lblGrantPermission.textColor = .white
        lblGrantPermission.numberOfLines = 2
        lblGrantPermission.textAlignment = .center
        
        noPermissionView.addSubview(lblGrantPermission)
        lblGrantPermission.snp.makeConstraints { make in
            make.bottom.equalTo(btnGrantPermission.snp.top).offset(-12)
            make.centerX.equalToSuperview()
        }
    }
    
    private func openAppSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func presentImagePickerController() {
//        let vc = UIImagePickerController()
//        vc.sourceType = .photoLibrary
//        vc.delegate = self
//        present(vc, animated: true)
    }
    
    @objc private func onButtonFrameLayerTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    private func setFrameImage(with item: SelfieFrame) {
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
    
    private func setMovieImage(with item: UIImage) {
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

// MARK: - AVCapturePhotoCaptureDelegate

extension SelfieCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
//            view.makeToast("error_capture_image".localized)
//            return
//        }
//        presentCropViewController(with: image)
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

