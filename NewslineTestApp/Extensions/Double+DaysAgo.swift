//
//  Double+DaysAgo.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 30.01.2024.
//

import Foundation

extension Double {
    func daysAgo() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let postDate = NSDate(timeIntervalSince1970: self)

        let date1 = calendar.startOfDay(for: today)
        let date2 = calendar.startOfDay(for: postDate as Date)

        let components = calendar.dateComponents([.day], from: date2, to: date1)
        return components.day!
    }
}
