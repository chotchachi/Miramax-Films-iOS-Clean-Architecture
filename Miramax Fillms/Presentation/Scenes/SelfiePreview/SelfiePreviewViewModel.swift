//
//  SelfiePreviewViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/10/2022.
//

import RxCocoa
import RxSwift
import XCoordinator
import UIKit
import Domain

enum FavoriteImageState {
    case successfully
    case failed
    case alreadyExist
}

class SelfiePreviewViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let popViewTrigger: Driver<Void>
        let addFavoriteTrigger: Driver<Void>
    }
    
    struct Output {
        let finalImage: Driver<UIImage>
        let favoriteImageState: Driver<FavoriteImageState>
    }
    
    private let repositoryProvider: RepositoryProviderProtocol
    private let router: UnownedRouter<SelfiePreviewRoute>
    private let finalImage: UIImage
    private let tempImageName: String
    
    init(repositoryProvider: RepositoryProviderProtocol, router: UnownedRouter<SelfiePreviewRoute>, finalImage: UIImage) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.finalImage = finalImage
        self.tempImageName = "img_\(Int(Date().timeIntervalSince1970)).jpg"
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let favoriteImageState = input.addFavoriteTrigger
            .asObservable()
            .flatMapLatest {
                self.saveImage(imageName: self.tempImageName, image: self.finalImage)
            }
            .asDriverOnErrorJustComplete()
        
        input.popViewTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.router.trigger(.pop)
            })
            .disposed(by: rx.disposeBag)
        
        return Output(
            finalImage: Driver.just(finalImage),
            favoriteImageState: favoriteImageState
        )
    }
    
    private func saveImage(imageName: String, image: UIImage) -> Single<FavoriteImageState> {
        return Single.create { single in
            guard let data = image.jpegData(compressionQuality: 1) else {
                single(.success(.failed))
                return Disposables.create()
            }
            
            let destinationURL = self.getFavoriteSelfieImagesDirectory()
            let fileURL = destinationURL.appendingPathComponent(imageName)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                single(.success(.alreadyExist))
            } else {
                do {
                    try data.write(to: fileURL)
                    single(.success(.successfully))
                } catch {
                    single(.success(.failed))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getFavoriteSelfieImagesDirectory() -> URL {
        let documentDestination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderDestination = documentDestination.appendingPathComponent("SelfieImages", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folderDestination.path) {
            try? FileManager.default.createDirectory(
                atPath: folderDestination.path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        print(folderDestination.path)
        return folderDestination
    }
}
