//
//  RMOperator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import RealmSwift

protocol RMOperator {
    associatedtype KeyType
    func primaryKey() -> KeyType
}
