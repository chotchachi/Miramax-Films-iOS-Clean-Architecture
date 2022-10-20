//
//  SelfieRepository.swift
//  Data
//
//  Created by Thanh Quang on 15/10/2022.
//

import Domain
import ObjectMapper
import RxSwift

public class SelfieRepository: SelfieRepositoryProtocol {
    private let localDataSource: LocalDataSourceProtocol
    
    public init(localDataSource: LocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }
    
    public func getAllFrame() -> [SelfieFrame] {
        if let url = ResourceManager.dataBundle.url(forResource: "selfie_frames", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let jsonData = Mapper<SelfieFrameDTO>().mapArray(JSONObject: json)
                let domainItems = jsonData.map { items in items.map { $0.asDomain() } }
                return domainItems ?? []
            } catch {
                print("Load selfie frame data failed with error: \(error.localizedDescription)")
                return []
            }
        } else {
            print("Load selfie frame data failed: File not found!")
            return []
        }
    }
    
    public func getAllFavoriteSelfie() -> Observable<[FavoriteSelfie]> {
        return localDataSource
            .getAllFavoriteSelfie()
            .map { items in items.map { $0.asDomain() } }
    }
    
    public func saveFavoriteSelfie(item: FavoriteSelfie) -> Completable {
        return localDataSource
            .saveFavoriteSelfie(item: item.asRealm())
    }
}
