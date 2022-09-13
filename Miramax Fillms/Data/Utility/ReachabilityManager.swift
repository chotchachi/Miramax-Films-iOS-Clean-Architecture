//
//  ReachabilityManager.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import Alamofire
import RxSwift

func connectedToInternet() -> Observable<Bool> {
    return ReachabilityManager.shared.reach
}

class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()

    let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return reachSubject.asObservable()
    }

    override init() {
        super.init()

        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                self.reachSubject.onNext(false)
            case .reachable:
                self.reachSubject.onNext(true)
            case .unknown:
                self.reachSubject.onNext(false)
            }
        })
    }
}
