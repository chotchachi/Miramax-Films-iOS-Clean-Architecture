//
//  Rx+retryWith.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/10/2022.
//

import RxSwift

extension ObservableType {
    func retryWith<O: ObservableConvertibleType>(_ retryTrigger: O) -> Observable<Element> {
        return retry(when: { _ in
            return retryTrigger.asObservable()
        })
    }
}
