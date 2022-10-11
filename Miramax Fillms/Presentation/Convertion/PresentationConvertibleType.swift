//
//  PresentationConvertibleType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 11/10/2022.
//

protocol PresentationConvertibleType {
    associatedtype PresentationType
    func asPresentation() -> PresentationType
}
