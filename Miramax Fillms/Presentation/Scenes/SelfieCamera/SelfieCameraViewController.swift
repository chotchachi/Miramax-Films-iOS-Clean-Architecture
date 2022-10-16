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

enum CameraDevice {
    case back, front
}

class SelfieCameraViewController: BaseViewController<SelfieCameraViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnSwitchCamera: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnMoreOption: UIButton!
    @IBOutlet weak var btnGallery: UIButton!

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
    
    // MARK: - Lifecycle

    override func configView() {
        super.configView()
        
        configureViews()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SelfieCameraViewModel.Input(
            backTrigger: btnBack.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
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
    
    private func presentCropViewController(with image: UIImage) {
//        let cropViewController = CropViewController(image: image)
//        cropViewController.aspectRatioPreset = .presetSquare
//        cropViewController.allowedAspectRatios = [.presetSquare]
//        cropViewController.aspectRatioLockEnabled = true
//        cropViewController.aspectRatioPickerButtonHidden = true
//        cropViewController.resetAspectRatioEnabled = false
//        cropViewController.cancelButtonTitle = "cancel".localized
//        cropViewController.cancelButtonColor = .red
//        cropViewController.doneButtonTitle = "done".localized
//        cropViewController.doneButtonColor = AppColors.colorPrimary
//        cropViewController.delegate = self
//        present(cropViewController, animated: true)
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
