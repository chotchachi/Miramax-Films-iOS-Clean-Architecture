//
//  SelfieCameraViewController+Capture.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/10/2022.
//

import Foundation
import UIKit
import AVFoundation
import SwifterSwift

extension SelfieCameraViewController {
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer()
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
    }

    func setupCamera() {
        isConfiguringCamera = true
        
        /// Init capture session
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = .medium
        videoPreviewLayer.session = captureSession!
        
        /// Get current camera device
        guard let cameraDevice = getCameraDevice() else { return }
        
        /// Add capture device output
        stillImageOutput = AVCapturePhotoOutput()
        if captureSession!.canAddOutput(stillImageOutput!) {
            captureSession!.addOutput(stillImageOutput!)
        }
        
        /// Add capture device input
        addCaptureDeviceInput(session: captureSession!, cameraDevice: cameraDevice) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self ] in
                self?.captureSession?.startRunning()
            }
        }
    }
    
    func stopCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self ] in
            self?.captureSession?.stopRunning()
            self?.captureSession = nil
            self?.stillImageOutput = nil
            self?.videoPreviewLayer.session = nil
        }
    }
    
    private func addCaptureDeviceInput(session: AVCaptureSession, cameraDevice: AVCaptureDevice, completion: () -> Void) {
        do {
            let input = try AVCaptureDeviceInput(device: cameraDevice)
                        
            if session.canAddInput(input) {
                session.addInput(input)
                self.isConfiguringCamera = false
                completion()
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                self.showAlert(title: "error".localized, message: "initialize_camera_device_error".localized)
            }
        }
    }
    
    func switchCameraDevice() {
        guard let captureSession = self.captureSession else { return }
        
        isConfiguringCamera = true
        
        /// Toggle camera device
        currentCameraDevice = currentCameraDevice == .back ? .front : .back
        setButtonFlash(isEnable: currentCameraDevice == .back)

        /// Get new camera device
        guard let newCameraDevice = getCameraDevice() else { return }
                
        captureSession.beginConfiguration()
        
        /// Remove current capture device input if exist
        if let currentCameraInput = captureSession.inputs.first {
            captureSession.removeInput(currentCameraInput)
        }
        
        /// Add capture device input
        addCaptureDeviceInput(session: captureSession, cameraDevice: newCameraDevice) { }
        
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
        
    func snapPhoto() {
        guard let stillImageOutput = self.stillImageOutput else { return }
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if device.torchMode == .on {
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

    func checkCameraPermission(completion: @escaping () -> Void) {
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
    
    func updateCameraViewsState(isEnable: Bool) {
        DispatchQueue.main.async {
            [self.btnCapture, self.btnSwitchCamera].forEach { button in
                button?.isEnabled = isEnable
            }
        }
    }
    
    func setButtonFlash(isEnable: Bool) {
        DispatchQueue.main.async {
            self.btnFlash.isEnabled = isEnable
        }
    }
    
    func visibleNoCameraPermissionView() {
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
}

// MARK: - AVCapturePhotoCaptureDelegate

extension SelfieCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            self.showAlert(title: "error".localized, message: "error_capture_image".localized)
            return
        }
        handleDoneCaptureView()
        if currentCameraDevice == .back {
            captureImageView.image = image
        } else {
            let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
            captureImageView.image = flippedImage
        }
    }
}
