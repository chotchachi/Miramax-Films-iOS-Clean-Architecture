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
import RxDataSources
import AVFoundation
import Kingfisher
import MaterialComponents.MaterialBottomSheet
import Domain

enum CameraDevice {
    case back, front
}

class SelfieCameraViewController: BaseViewController<SelfieCameraViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewViewHeightConstraint: NSLayoutConstraint!
    
    /// To hold capture image, frame image, movie poster image
    /// Using to export the final image
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var canvasViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasViewHeightConstraint: NSLayoutConstraint!

    /// To hold capture image
    @IBOutlet weak var captureImageView: UIImageView!

    /// To hold selfie frame
    @IBOutlet weak var frameView: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSwitchCamera: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var btnEditForm: UIButton!
    
    @IBOutlet weak var viewCameraControls: UIView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnFrameLayer: UIView!
    @IBOutlet weak var btnGallery: UIView!

    @IBOutlet weak var viewFrameLayer: UIView!
    @IBOutlet weak var btnCloseViewFrameLayer: UIButton!
    @IBOutlet weak var btnNoFrameLayer: UIButton!
    @IBOutlet weak var btnDoneSelectFrameLayer: UIButton!
    @IBOutlet weak var frameLayerCollectionView: UICollectionView!

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
    
    /// Current frame elements
    var currentSelfieFrame: SelfieFrame?
    var currentMovie: EntertainmentViewModel!
    var currentFormLocation: String?
    var currentFormDate: Date?
    
    private var tempSelectionSelfieFrame: SelfieFrame? /// Using to hold selection selfie frame

    /// Relay
    let selecteSelfieFrameTriggerS = PublishRelay<SelfieFrame?>()
    let selectMovieImageTriggerS = PublishRelay<Void>()
    let doneTriggerS = PublishRelay<(UIImage, SelfieFrame?)>()
    
    // MARK: - Lifecycle

    override func configView() {
        super.configView()
        
        configureViews()
        setupLivePreview()
        updateCameraViewsState(isEnable: false)
        setButtonFlash(isEnable: currentCameraDevice == .back)
        configureFrameLayerView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SelfieCameraViewModel.Input(
            popViewTrigger: btnBack.rx.tap.asDriver(),
            selectMovieImageTrigger: selectMovieImageTriggerS.asDriverOnErrorJustComplete(),
            selectSelfieFrameTrigger: selecteSelfieFrameTriggerS.asDriverOnErrorJustComplete(),
            doneTrigger: doneTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        Driver.combineLatest(output.selfieFrame, output.movie)
            .drive(onNext: { [weak self] (selfieFrame, movie) in
                guard let self = self else { return }
                self.currentSelfieFrame = selfieFrame
                self.currentMovie = movie
                self.setFrame(with: selfieFrame, and: movie)
            })
            .disposed(by: rx.disposeBag)
        
        let frameDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, SelfieFrame>> { datasource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: SelfieFrameThumbCollectionViewCell.self, for: indexPath)
            cell.bind(item, canSelection: true)
            return cell
        }
        
        output.selfieFrameData
            .map { [SectionModel(model: "", items: $0)] }
            .drive(frameLayerCollectionView.rx.items(dataSource: frameDataSource))
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
        
        btnEditForm.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.presentEditFormSheet()
            })
            .disposed(by: rx.disposeBag)
        
        btnRetake.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.startNewCapture()
            })
            .disposed(by: rx.disposeBag)

        btnCloseViewFrameLayer.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.visibleViewFrameLayer(isVisible: false)
                self.tempSelectionSelfieFrame = nil /// Reset temp selfie frame
                self.setFrame(with: self.currentSelfieFrame, and: self.currentMovie)
            })
            .disposed(by: rx.disposeBag)
        
        btnNoFrameLayer.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tempSelectionSelfieFrame = nil
                self.setFrame(with: nil, and: self.currentMovie)
            })
            .disposed(by: rx.disposeBag)
        
        btnDoneSelectFrameLayer.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.visibleViewFrameLayer(isVisible: false)
                self.selecteSelfieFrameTriggerS.accept(self.tempSelectionSelfieFrame)
                self.tempSelectionSelfieFrame = nil /// Reset temp selfie frame
            })
            .disposed(by: rx.disposeBag)
        
        btnDone.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let finalImage = self.canvasView.toImage()
                self.doneTriggerS.accept((finalImage, self.currentSelfieFrame))
            })
            .disposed(by: rx.disposeBag)
        
        btnFrameLayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onButtonFrameLayerTapped(_:))))
        btnGallery.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onButtonGalleryTapped(_:))))

        captureImageView.contentMode = .scaleAspectFill
    }
    
    private func configureFrameLayerView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        frameLayerCollectionView.collectionViewLayout = collectionViewLayout
        frameLayerCollectionView.register(cellWithClass: SelfieFrameThumbCollectionViewCell.self)
        frameLayerCollectionView.delegate = self
        frameLayerCollectionView.showsHorizontalScrollIndicator = false
        frameLayerCollectionView.rx.modelSelected(SelfieFrame.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.tempSelectionSelfieFrame = item
                self.setFrame(with: item, and: self.currentMovie)
            })
            .disposed(by: rx.disposeBag)
    }
    
    @objc private func onButtonFrameLayerTapped(_ sender: UITapGestureRecognizer) {
        visibleViewFrameLayer(isVisible: true)
    }
    
    @objc private func onButtonGalleryTapped(_ sender: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func visibleViewFrameLayer(isVisible: Bool) {
        viewCameraControls.isHidden = isVisible
        viewFrameLayer.isHidden = !isVisible
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
    
    private func presentEditFormSheet() {
        let optionsVC = SelfieCameraOptionsViewController()
        optionsVC.selectedLocation = currentFormLocation
        optionsVC.selectedDate = currentFormDate
        optionsVC.onDoneAction = { [weak self] results in
            guard let self = self else { return }
            self.currentFormDate = results.date
            self.setFrameDateText(with: results.date)
            self.currentFormLocation = results.location
            self.setFrameLocationText(with: results.location)
        }
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: optionsVC)
        bottomSheet.preferredContentSize = CGSize(width: view.width, height: view.height)
        bottomSheet.delegate = self
        present(bottomSheet, animated: true)
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

// MARK: - UICollectionViewDelegateFlowLayout

extension SelfieCameraViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height
        let itemWidth = itemHeight * DimensionConstants.selfieFrameThumbCellRatio
        return .init(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16.0, bottom: 0.0, right: 16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DimensionConstants.selfieFrameThumbCellSpacing
    }
}

// MARK: - MDCBottomSheetControllerDelegate

extension SelfieCameraViewController: MDCBottomSheetControllerDelegate {
    func bottomSheetControllerStateChanged(_ controller: MDCBottomSheetController, state: MDCSheetState) {
        if state == .closed {
            controller.dismissKeyboard()
        }
    }
}
