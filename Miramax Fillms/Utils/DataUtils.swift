//
//  DataUtils.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

class DataUtils {
    static func getRatingText(_ voteAverage: Double) -> String {
        return "\(round(voteAverage * 10) / 10.0)"
    }
    
    static func getDurationText(_ duration: Int?) -> String {
        guard let duration = duration else { return "" }
        let hour = duration / 60
        let minutesLeft = duration % 60
        if hour > 0 {
            if minutesLeft != 0 {
                return "\(hour)h\(minutesLeft)m"
            }
            return "\(hour)h"
        }
        return "\(minutesLeft)m"
    }
    
    static func getReleaseYear(_ strDate: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.apiDateResponseFormat
        let date = dateFormatter.date(from: strDate)
        return date?.get(.year)
    }
}
