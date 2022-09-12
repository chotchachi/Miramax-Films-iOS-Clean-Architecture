//
//  ViewModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
