//
//  RealmRepresentable.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 23/09/2022.
//

protocol RealmRepresentable {
    associatedtype RealmType
//    var uid: String { get }
    func asRealm() -> RealmType
}
