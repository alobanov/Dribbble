//
//  ServerDateTransform.swift
//  Dribbble
//
//  Created by Lobanov Aleksey on 10.08.16.
//  Copyright © 2016 Lobanov Aleksey. All rights reserved.
//

import ObjectMapper

class ServerDateTransform: TransformType {
    typealias Object = NSDate
    typealias JSON = Double
    
    init() {}
    
    lazy private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        formatter.locale = NSLocale.current as Locale!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //"2017-01-18T14:31:01Z" //2016-08-10T15:12:10.2924646+04:00
        
        return formatter
    }()
    
    public func transformFromJSON(_ value: Any?) -> NSDate? {
        if let timeStr = value as? String {
            let date = dateFormatter.date(from: timeStr)
            return NSDate(timeIntervalSince1970: (date?.timeIntervalSince1970)!)
        }
        
        return nil
    }
    
    func transformToJSON(_ value: NSDate?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970)
        }
        return nil
    }
}
