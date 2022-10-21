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
    private let selfieFrame: SelfieFrame
    private let tempImageName: String
    
    init(repositoryProvider: RepositoryProviderProtocol,
         router: UnownedRouter<SelfiePreviewRoute>,
         finalImage: UIImage,
         selfieFrame: SelfieFrame
    ) {
        self.repositoryProvider = repositoryProvider
        self.router = router
        self.finalImage = finalImage
        self.selfieFrame = selfieFrame
        self.tempImageName = "img_\(Int(Date().timeIntervalSince1970))"
        super.init()
        storedRecentSelfieFrame(with: selfieFrame)
    }
    
    func transform(input: Input) -> Output {
        let favoriteImageState = input.addFavoriteTrigger
            .asObservable()
            .flatMapLatest {
                self.saveImage(imageName: self.tempImageName.appending(".jpg"), image: self.finalImage)
                    .andThen(self.storedFavoriteSelfieImage())
                    .andThen(Observable.just(FavoriteImageState.successfully))
                    .catch({ error in
                        if (error as NSError).code == 2 {
                            return Observable.just(FavoriteImageState.alreadyExist)
                        } else {
                            return Observable.just(FavoriteImageState.failed)
                        }
                    })
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
    
    private func saveImage(imageName: String, image: UIImage) -> Completable {
        return Completable.create { completable in
            guard let data = image.jpegData(compressionQuality: 1) else {
                completable(.error(NSError(domain: "Get UIImage jpeg data failed.", code: 1)))
                return Disposables.create()
            }
            
            let destinationURL = self.getFavoriteSelfieImagesDirectory()
            let fileURL = destinationURL.appendingPathComponent(imageName)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                completable(.error(NSError(domain: "File already exist.", code: 2)))
            } else {
                do {
                    try data.write(to: fileURL)
                    completable(.completed)
                } catch {
                    completable(.error(NSError(domain: "Write image data failed.", code: 3)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func storedFavoriteSelfieImage() -> Completable {
        let favoriteSelfie = FavoriteSelfie(
            name: self.tempImageName,
            frame: self.selfieFrame.name,
            userLocation: nil,
            userCreateDate: nil,
            createAt: Date()
        )
        return repositoryProvider
            .selfieRepository()
            .saveFavoriteSelfie(item: favoriteSelfie)
    }
    
    private func storedRecentSelfieFrame(with selfieFrame: SelfieFrame) {
        let defaults = Defaults.shared
        var recentSelfieFrames = defaults.get(for: .recentSelfieFrames) ?? []
        recentSelfieFrames.removeAll(where: { $0 == selfieFrame.name }) // Remove if exist
        recentSelfieFrames.append(selfieFrame.name)
        defaults.set(recentSelfieFrames, for: .recentSelfieFrames)
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
