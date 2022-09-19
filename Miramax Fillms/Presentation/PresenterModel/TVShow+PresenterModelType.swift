//
//  TVShow+PresenterModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

extension TVShow: PresenterModelType {
    var thumbImageURL: URL? {
        return posterURL
    }
    
    var backdropImageURL: URL? {
        return backdropURL
    }
    
    var textName: String {
        return name
    }
    
    var textDescription: String {
        return overview
    }
}