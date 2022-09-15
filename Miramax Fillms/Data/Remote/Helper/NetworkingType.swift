//
//  NetworkingType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Moya

protocol NetworkingType {
    associatedtype T: TargetType
    var provider: NetworkProvider<T> { get }
    
    static func getNetworking() -> Self
}
