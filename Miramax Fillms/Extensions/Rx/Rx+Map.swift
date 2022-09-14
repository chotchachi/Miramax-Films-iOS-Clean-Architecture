//
//  Rx+Map.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 14/09/2022.
//

import RxSwift
import RxCocoa

struct MapFromNever: Error {}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    /// Convert Observer to Observer void
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func map<T>(to: T.Type) -> Observable<T> {
        return self.flatMap { _ in
            return Observable<T>.error(MapFromNever())
        }
    }
}
